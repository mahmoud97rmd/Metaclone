import 'package:logger/logger.dart';
import '../../../domain/entities/trade.dart';
import '../../../domain/entities/account.dart';

class VirtualAccount {
  final Logger logger;
  double _balance;
  final double _initialBalance;
  final List<Trade> _openTrades = [];
  final List<Trade> _closedTrades = [];

  VirtualAccount({
    required this.logger,
    required double initialBalance,
  })  : _initialBalance = initialBalance,
        _balance = initialBalance;

  double get balance => _balance;
  double get initialBalance => _initialBalance;
  List<Trade> get openTrades => List.unmodifiable(_openTrades);
  List<Trade> get closedTrades => List.unmodifiable(_closedTrades);

  double get equity {
    final floatingPL = _openTrades.fold<double>(
      0,
      (sum, trade) => sum + (trade.realizedProfitLoss ?? 0),
    );
    return _balance + floatingPL;
  }

  double get realizedPL {
    return _closedTrades.fold<double>(
      0,
      (sum, trade) => sum + (trade.realizedProfitLoss ?? 0),
    );
  }

  double get unrealizedPL {
    return _openTrades.fold<double>(
      0,
      (sum, trade) => sum + (trade.realizedProfitLoss ?? 0),
    );
  }

  Account getAccountSnapshot() {
    return Account(
      id: 'VIRTUAL_ACCOUNT',
      balance: _balance,
      equity: equity,
      usedMargin: 0,
      freeMargin: equity,
      marginLevel: 0,
      realizedPL: realizedPL,
      unrealizedPL: unrealizedPL,
      currency: 'USD',
      lastUpdate: DateTime.now(),
    );
  }

  void openTrade(Trade trade) {
    _openTrades.add(trade);
    logger.i('Trade opened: ${trade.id}');
  }

  void closeTrade(String tradeId, {required double exitPrice}) {
    final tradeIndex = _openTrades.indexWhere((t) => t.id == tradeId);
    
    if (tradeIndex == -1) {
      logger.w('Trade not found: $tradeId');
      return;
    }

    final trade = _openTrades.removeAt(tradeIndex);
    final profitLoss = _calculateProfitLoss(trade, exitPrice);
    
    _balance += profitLoss;

    final closedTrade = trade.copyWith(
      exitPrice: exitPrice,
      closeTime: DateTime.now(),
      status: TradeStatus.closed,
      realizedProfitLoss: profitLoss,
    );

    _closedTrades.add(closedTrade);
    logger.i('Trade closed: $tradeId, P&L: $profitLoss');
  }

  double _calculateProfitLoss(Trade trade, double exitPrice) {
    final priceDiff = trade.type == TradeType.buy
        ? exitPrice - trade.entryPrice
        : trade.entryPrice - exitPrice;

    return priceDiff * trade.lotSize * 100000;
  }

  void reset() {
    _balance = _initialBalance;
    _openTrades.clear();
    _closedTrades.clear();
    logger.i('Account reset');
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': _balance,
      'initialBalance': _initialBalance,
      'equity': equity,
      'realizedPL': realizedPL,
      'unrealizedPL': unrealizedPL,
      'openTrades': _openTrades.map((t) => {
        'id': t.id,
        'instrument': t.instrument,
        'type': t.type.toString(),
        'lotSize': t.lotSize,
        'entryPrice': t.entryPrice,
        'openTime': t.openTime.toIso8601String(),
      }).toList(),
      'closedTrades': _closedTrades.map((t) => {
        'id': t.id,
        'profitLoss': t.realizedProfitLoss,
      }).toList(),
    };
  }

  factory VirtualAccount.fromJson(Map<String, dynamic> json, Logger logger) {
    final account = VirtualAccount(
      logger: logger,
      initialBalance: (json['initialBalance'] as num).toDouble(),
    );
    
    account._balance = (json['balance'] as num).toDouble();
    
    if (json['openTrades'] != null) {
      final openTradesList = json['openTrades'] as List<dynamic>;
      for (final tradeJson in openTradesList) {
        if (tradeJson is Map<String, dynamic>) {
          final tradeType = tradeJson['type'] == 'TradeType.buy' 
              ? TradeType.buy 
              : TradeType.sell;
          
          final trade = Trade(
            id: tradeJson['id'] as String,
            instrument: tradeJson['instrument'] as String,
            type: tradeType,
            lotSize: (tradeJson['lotSize'] as num).toDouble(),
            entryPrice: (tradeJson['entryPrice'] as num).toDouble(),
            openTime: DateTime.parse(tradeJson['openTime'] as String),
            status: TradeStatus.open,
          );
          
          account._openTrades.add(trade);
        }
      }
    }
    
    if (json['closedTrades'] != null) {
      final closedTradesList = json['closedTrades'] as List<dynamic>;
      for (final tradeJson in closedTradesList) {
        if (tradeJson is Map<String, dynamic>) {
          final trade = Trade(
            id: tradeJson['id'] as String,
            instrument: '',
            type: TradeType.buy,
            lotSize: 0,
            entryPrice: 0,
            openTime: DateTime.now(),
            status: TradeStatus.closed,
            realizedProfitLoss: (tradeJson['profitLoss'] as num?)?.toDouble(),
          );
          
          account._closedTrades.add(trade);
        }
      }
    }
    
    return account;
  }
}
