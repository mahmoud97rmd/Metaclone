/// ═══════════════════════════════════════════════════════════
/// Position Manager
/// إدارة المراكز المفتوحة وحساب الأرباح والخسائر
/// ═══════════════════════════════════════════════════════════
library;

import 'package:logger/logger.dart';

import '../../../domain/entities/trade.dart';
import '../../../domain/entities/tick.dart';

class PositionManager {
  final Logger _logger;

  PositionManager({required Logger logger}) : _logger = logger;

  /// تحديث جميع المراكز بناءً على Tick جديد
  List<Trade> updatePositions({
    required List<Trade> positions,
    required Tick tick,
  }) {
    final updatedPositions = <Trade>[];

    for (final position in positions) {
      if (position.instrument != tick.instrument) {
        updatedPositions.add(position);
        continue;
      }

      // السعر الحالي (استخدام Bid للبيع و Ask للشراء)
      final currentPrice = position.type == TradeType.buy 
          ? tick.bid 
          : tick.ask;

      // فحص Stop Loss
      if (position.hitStopLoss(currentPrice)) {
        _logger.w('Position ${position.id} hit Stop Loss @ $currentPrice');
        // سيتم إغلاقها من قبل VirtualAccount
      }

      // فحص Take Profit
      if (position.hitTakeProfit(currentPrice)) {
        _logger.i('Position ${position.id} hit Take Profit @ $currentPrice');
        // سيتم إغلاقها من قبل VirtualAccount
      }

      updatedPositions.add(position);
    }

    return updatedPositions;
  }

  /// حساب إجمالي P&L لجميع المراكز
  double calculateTotalPL({
    required List<Trade> positions,
    required Map<String, double> currentPrices,
  }) {
    double totalPL = 0;

    for (final position in positions) {
      final price = currentPrices[position.instrument];
      if (price != null) {
        totalPL += position.calculateFloatingPL(price, 10.0);
      }
    }

    return totalPL;
  }

  /// حساب P&L بالنقاط (Pips)
  Map<String, double> calculatePipsGains({
    required List<Trade> positions,
    required Map<String, double> currentPrices,
  }) {
    final pipsGains = <String, double>{};

    for (final position in positions) {
      final price = currentPrices[position.instrument];
      if (price != null) {
        pipsGains[position.id] = position.calculatePipsGain(price);
      }
    }

    return pipsGains;
  }

  /// تجميع المراكز حسب الأداة
  Map<String, List<Trade>> groupByInstrument(List<Trade> positions) {
    final grouped = <String, List<Trade>>{};

    for (final position in positions) {
      grouped.putIfAbsent(position.instrument, () => []);
      grouped[position.instrument]!.add(position);
    }

    return grouped;
  }

  /// حساب صافي المراكز (Net Position) لكل أداة
  Map<String, double> calculateNetPositions(List<Trade> positions) {
    final netPositions = <String, double>{};

    for (final position in positions) {
      netPositions.putIfAbsent(position.instrument, () => 0);
      
      final lotSize = position.type == TradeType.buy 
          ? position.lotSize 
          : -position.lotSize;
      
      netPositions[position.instrument] = 
          netPositions[position.instrument]! + lotSize;
    }

    return netPositions;
  }

  /// الحصول على أفضل/أسوأ صفقة
  Trade? getBestTrade(List<Trade> closedTrades) {
    if (closedTrades.isEmpty) return null;

    return closedTrades.reduce((a, b) {
      final apl = a.realizedProfitLoss ?? 0;
      final bpl = b.realizedProfitLoss ?? 0;
      return apl > bpl ? a : b;
    });
  }

  Trade? getWorstTrade(List<Trade> closedTrades) {
    if (closedTrades.isEmpty) return null;

    return closedTrades.reduce((a, b) {
      final apl = a.realizedProfitLoss ?? 0;
      final bpl = b.realizedProfitLoss ?? 0;
      return apl < bpl ? a : b;
    });
  }

  /// حساب متوسط مدة الصفقات
  Duration? getAverageTradeDuration(List<Trade> closedTrades) {
    if (closedTrades.isEmpty) return null;

    final totalDuration = closedTrades.fold<Duration>(
      Duration.zero,
      (sum, trade) => sum + trade.duration,
    );

    return totalDuration ~/ closedTrades.length;
  }
}
