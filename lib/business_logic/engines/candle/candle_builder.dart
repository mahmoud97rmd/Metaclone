/// ═══════════════════════════════════════════════════════════
/// Candle Builder
/// يبني الشموع من البيانات التاريخية
/// ═══════════════════════════════════════════════════════════

import '../../../core/constants/timeframe_constants.dart';
import '../../../domain/entities/candle.dart';

class CandleBuilder {
  /// تحويل إطار زمني أصغر إلى أكبر
  /// مثال: تحويل M1 إلى M5
  static List<Candle> aggregateCandles({
    required List<Candle> sourceCandles,
    required Timeframe sourceTimeframe,
    required Timeframe targetTimeframe,
  }) {
    if (sourceCandles.isEmpty) return [];

    // التحقق من أن target أكبر من source
    if (targetTimeframe.milliseconds <= sourceTimeframe.milliseconds) {
      throw ArgumentError(
        'Target timeframe must be larger than source timeframe',
      );
    }

    final aggregatedCandles = <Candle>[];
    final targetMs = targetTimeframe.milliseconds;

    Candle? currentAggregate;
    int currentPeriodStart = 0;

    for (final candle in sourceCandles) {
      final candleTime = candle.time;
      final periodStart = (candleTime ~/ targetMs) * targetMs;

      if (currentAggregate == null || periodStart != currentPeriodStart) {
        // حفظ الشمعة السابقة
        if (currentAggregate != null) {
          aggregatedCandles.add(currentAggregate);
        }

        // بدء شمعة جديدة
        currentAggregate = Candle(
          time: periodStart,
          open: candle.open,
          high: candle.high,
          low: candle.low,
          close: candle.close,
          volume: candle.volume,
          instrument: candle.instrument,
          isComplete: candle.isComplete,
        );
        currentPeriodStart = periodStart;
      } else {
        // دمج مع الشمعة الحالية
        currentAggregate = currentAggregate.copyWith(
          high: candle.high > currentAggregate.high
              ? candle.high
              : currentAggregate.high,
          low: candle.low < currentAggregate.low
              ? candle.low
              : currentAggregate.low,
          close: candle.close,
          volume: currentAggregate.volume != null && candle.volume != null
              ? currentAggregate.volume! + candle.volume!
              : null,
          isComplete: candle.isComplete,
        );
      }
    }

    // إضافة الشمعة الأخيرة
    if (currentAggregate != null) {
      aggregatedCandles.add(currentAggregate);
    }

    return aggregatedCandles;
  }

  /// حساب نقاط البايفوت (Pivot Points)
  static Map<String, double> calculatePivotPoints(Candle candle) {
    final pivot = (candle.high + candle.low + candle.close) / 3;
    final r1 = (2 * pivot) - candle.low;
    final s1 = (2 * pivot) - candle.high;
    final r2 = pivot + (candle.high - candle.low);
    final s2 = pivot - (candle.high - candle.low);
    final r3 = candle.high + 2 * (pivot - candle.low);
    final s3 = candle.low - 2 * (candle.high - pivot);

    return {
      'pivot': pivot,
      'r1': r1,
      'r2': r2,
      'r3': r3,
      's1': s1,
      's2': s2,
      's3': s3,
    };
  }

  /// حساب متوسط المدى (Average Range)
  static double calculateAverageRange(List<Candle> candles) {
    if (candles.isEmpty) return 0;

    final totalRange = candles.fold<double>(
      0,
      (sum, candle) => sum + candle.range,
    );

    return totalRange / candles.length;
  }
}
