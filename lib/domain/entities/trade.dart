/// ═══════════════════════════════════════════════════════════
/// Trade Entity - نسخة محدثة ومكتملة
/// ═══════════════════════════════════════════════════════════
library;

import 'package:equatable/equatable.dart';

enum TradeType { buy, sell }

extension TradeTypeExtension on TradeType {
  String get code => this == TradeType.buy ? 'BUY' : 'SELL';
}

enum TradeStatus { 
  open, 
  closed, 
  pending, 
  cancelled 
}

class Trade extends Equatable {
  final String id;
  final TradeType type;
  final String instrument;
  final double entryPrice;
  final double? exitPrice;
  final double lotSize;
  final DateTime openTime;
  final DateTime? closeTime;
  final double? stopLoss;
  final double? takeProfit;
  final TradeStatus status;
  final double? realizedProfitLoss;
  final double commission;
  final double swap;
  final String? notes;

  const Trade({
    required this.id,
    required this.type,
    required this.instrument,
    required this.entryPrice,
    this.exitPrice,
    required this.lotSize,
    required this.openTime,
    this.closeTime,
    this.stopLoss,
    this.takeProfit,
    this.status = TradeStatus.open,
    this.realizedProfitLoss,
    this.commission = 0,
    this.swap = 0,
    this.notes,
  });

  // ════════════════════════════════════════════════════════════
  // Calculations
  // ════════════════════════════════════════════════════════════

  /// حساب الربح/الخسارة العائم
  double calculateFloatingPL(double currentPrice, double pipValue) {
    final priceDifference = type == TradeType.buy
        ? currentPrice - entryPrice
        : entryPrice - currentPrice;

    // تحويل إلى نقاط (Pips)
    final pips = priceDifference * (instrument.startsWith('XAU') ? 1 : 10000);

    // حساب P&L
    return (pips * lotSize * pipValue) - commission - swap;
  }

  /// حساب الربح/الخسارة بالنقاط (Pips)
  double calculatePipsGain(double currentPrice) {
    final priceDifference = type == TradeType.buy
        ? currentPrice - entryPrice
        : entryPrice - currentPrice;

    return priceDifference * (instrument.startsWith('XAU') ? 1 : 10000);
  }

  /// هل تم ضرب Stop Loss؟
  bool hitStopLoss(double currentPrice) {
    if (stopLoss == null) return false;

    if (type == TradeType.buy) {
      return currentPrice <= stopLoss!;
    } else {
      return currentPrice >= stopLoss!;
    }
  }

  /// هل تم ضرب Take Profit؟
  bool hitTakeProfit(double currentPrice) {
    if (takeProfit == null) return false;

    if (type == TradeType.buy) {
      return currentPrice >= takeProfit!;
    } else {
      return currentPrice <= takeProfit!;
    }
  }

  /// مدة الصفقة
  Duration get duration {
    final endTime = closeTime ?? DateTime.now();
    return endTime.difference(openTime);
  }

  /// نسبة الربح/الخسارة
  double? get profitPercentage {
    if (realizedProfitLoss == null) return null;
    
    final investedAmount = lotSize * 100000 * entryPrice;
    return (realizedProfitLoss! / investedAmount) * 100;
  }

  /// هل الصفقة رابحة؟
  bool get isProfit => (realizedProfitLoss ?? 0) >= 0;

  // ════════════════════════════════════════════════════════════
  // Copy With
  // ════════════════════════════════════════════════════════════

  Trade copyWith({
    String? id,
    TradeType? type,
    String? instrument,
    double? entryPrice,
    double? exitPrice,
    double? lotSize,
    DateTime? openTime,
    DateTime? closeTime,
    double? stopLoss,
    double? takeProfit,
    TradeStatus? status,
    double? realizedProfitLoss,
    double? commission,
    double? swap,
    String? notes,
  }) {
    return Trade(
      id: id ?? this.id,
      type: type ?? this.type,
      instrument: instrument ?? this.instrument,
      entryPrice: entryPrice ?? this.entryPrice,
      exitPrice: exitPrice ?? this.exitPrice,
      lotSize: lotSize ?? this.lotSize,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      status: status ?? this.status,
      realizedProfitLoss: realizedProfitLoss ?? this.realizedProfitLoss,
      commission: commission ?? this.commission,
      swap: swap ?? this.swap,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        instrument,
        entryPrice,
        exitPrice,
        lotSize,
        openTime,
        closeTime,
        stopLoss,
        takeProfit,
        status,
        realizedProfitLoss,
        commission,
        swap,
        notes,
      ];

  @override
  String toString() {
    return 'Trade(id: $id, type: ${type.code}, instrument: $instrument, '
        'entryPrice: $entryPrice, lotSize: $lotSize, status: $status)';
  }
}

extension TradeExtensions on Trade {
  bool hitStopLoss(double currentPrice) {
    if (stopLoss == null) return false;
    
    if (type == TradeType.buy) {
      return currentPrice <= stopLoss!;
    } else {
      return currentPrice >= stopLoss!;
    }
  }

  bool hitTakeProfit(double currentPrice) {
    if (takeProfit == null) return false;
    
    if (type == TradeType.buy) {
      return currentPrice >= takeProfit!;
    } else {
      return currentPrice <= takeProfit!;
    }
  }

  Trade copyWith({
    String? id,
    TradeType? type,
    String? instrument,
    double? entryPrice,
    double? exitPrice,
    double? lotSize,
    DateTime? openTime,
    DateTime? closeTime,
    double? stopLoss,
    double? takeProfit,
    TradeStatus? status,
    double? realizedProfitLoss,
    String? notes,
  }) {
    return Trade(
      id: id ?? this.id,
      type: type ?? this.type,
      instrument: instrument ?? this.instrument,
      entryPrice: entryPrice ?? this.entryPrice,
      exitPrice: exitPrice ?? this.exitPrice,
      lotSize: lotSize ?? this.lotSize,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      status: status ?? this.status,
      realizedProfitLoss: realizedProfitLoss ?? this.realizedProfitLoss,
      notes: notes ?? this.notes,
    );
  }
}
