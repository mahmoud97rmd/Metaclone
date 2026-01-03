import 'dart:async';
import 'package:logger/logger.dart';
import '../../../domain/entities/candle.dart';
import '../../../domain/entities/trade.dart';
import '../strategy/strategy_engine.dart';
import '../trading/virtual_account.dart';

class BacktestResult {
  final double initialBalance;
  final double finalBalance;
  final double totalProfit;
  final double totalLoss;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double maxDrawdown;
  final Duration duration;
  final List<Trade> trades;

  BacktestResult({
    required this.initialBalance,
    required this.finalBalance,
    required this.totalProfit,
    required this.totalLoss,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.maxDrawdown,
    required this.duration,
    required this.trades,
  });

  double get netProfit => finalBalance - initialBalance;
  double get profitFactor => totalLoss != 0 ? totalProfit / totalLoss : 0;
  double get returnPercentage => ((finalBalance - initialBalance) / initialBalance) * 100;
}

class BacktestEngine {
  final Logger logger;
  final StrategyEngine strategyEngine;

  BacktestEngine({
    required this.logger,
    required this.strategyEngine,
  });

  Future<BacktestResult> runBacktest({
    required List<Candle> candles,
    required double initialBalance,
    required String strategyName,
  }) async {
    logger.i('Starting backtest');

    final virtualAccount = VirtualAccount(
      logger: logger,
      initialBalance: initialBalance,
    );

    final startTime = DateTime.now();
    double maxBalance = initialBalance;
    double maxDrawdown = 0;

    for (int i = 50; i < candles.length; i++) {
      final historicalCandles = candles.sublist(0, i + 1);
      final currentCandle = candles[i];

      final signal = await strategyEngine.generateSignal(
        candles: historicalCandles,
        currentPrice: currentCandle.close,
      );

      if (signal != null) {
        executeSignal(virtualAccount, signal, currentCandle);
      }

      updateOpenTrades(virtualAccount, currentCandle);

      final currentBalance = virtualAccount.equity;
      if (currentBalance > maxBalance) {
        maxBalance = currentBalance;
      }
      final drawdown = ((maxBalance - currentBalance) / maxBalance) * 100;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }

    closeAllTrades(virtualAccount, candles.last.close);

    final duration = DateTime.now().difference(startTime);
    final result = calculateResults(
      virtualAccount: virtualAccount,
      initialBalance: initialBalance,
      maxDrawdown: maxDrawdown,
      duration: duration,
    );

    logger.i('Backtest completed');
    return result;
  }

  void executeSignal(
    VirtualAccount account,
    Map<String, dynamic> signal,
    Candle candle,
  ) {
    final tradeType = signal['type'] as String;
    final lotSize = signal['lotSize'] as double? ?? 0.1;
    final stopLoss = signal['stopLoss'] as double?;
    final takeProfit = signal['takeProfit'] as double?;

    final trade = Trade(
      id: 'bt_${candle.time.millisecondsSinceEpoch}',
      type: tradeType == 'BUY' ? TradeType.buy : TradeType.sell,
      instrument: 'BACKTEST',
      entryPrice: candle.close,
      lotSize: lotSize,
      openTime: candle.time,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      status: TradeStatus.open,
    );

    account.openTrade(trade);
  }

  void updateOpenTrades(VirtualAccount account, Candle candle) {
    for (final trade in List.from(account.openTrades)) {
      if (trade.stopLoss != null && trade.hitStopLoss(candle.close)) {
        account.closeTrade(trade.id, exitPrice: trade.stopLoss!);
      } else if (trade.takeProfit != null && trade.hitTakeProfit(candle.close)) {
        account.closeTrade(trade.id, exitPrice: trade.takeProfit!);
      }
    }
  }

  void closeAllTrades(VirtualAccount account, double exitPrice) {
    final openTradeIds = account.openTrades.map((t) => t.id).toList();
    for (final tradeId in openTradeIds) {
      account.closeTrade(tradeId, exitPrice: exitPrice);
    }
  }

  BacktestResult calculateResults({
    required VirtualAccount virtualAccount,
    required double initialBalance,
    required double maxDrawdown,
    required Duration duration,
  }) {
    final trades = virtualAccount.closedTrades;
    final winningTrades = trades.where((t) => (t.realizedProfitLoss ?? 0) > 0).toList();
    final losingTrades = trades.where((t) => (t.realizedProfitLoss ?? 0) < 0).toList();

    final totalProfit = winningTrades.fold<double>(
      0,
      (sum, t) => sum + (t.realizedProfitLoss ?? 0),
    );

    final totalLoss = losingTrades.fold<double>(
      0,
      (sum, t) => sum + (t.realizedProfitLoss ?? 0).abs(),
    );

    return BacktestResult(
      initialBalance: initialBalance,
      finalBalance: virtualAccount.balance,
      totalProfit: totalProfit,
      totalLoss: totalLoss,
      totalTrades: trades.length,
      winningTrades: winningTrades.length,
      losingTrades: losingTrades.length,
      winRate: trades.isEmpty ? 0 : (winningTrades.length / trades.length) * 100,
      maxDrawdown: maxDrawdown,
      duration: duration,
      trades: trades,
    );
  }
}
