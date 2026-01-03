/// ═══════════════════════════════════════════════════════════
/// EMA (Exponential Moving Average) Calculator
/// المتوسط المتحرك الأسي
/// ═══════════════════════════════════════════════════════════
library;

import '../../../domain/entities/candle.dart';
import '../../../domain/entities/indicator.dart';
import 'base_indicator_calculator.dart';

class EMACalculator extends BaseIndicatorCalculator<IndicatorValue> {
  final int period;
  final String indicatorId;

  // تخزين آخر قيمة EMA للحساب التدريجي
  double? _lastEma;

  EMACalculator({
    required this.period,
    required this.indicatorId,
  });

  @override
  bool validateParameters() {
    return period > 0;
  }

  @override
  List<IndicatorValue> calculate(List<Candle> candles) {
    if (!validateParameters() || candles.length < period) {
      return [];
    }

    final results = <IndicatorValue>[];
    final multiplier = 2.0 / (period + 1);

    // حساب SMA للقيم الأولى
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    double ema = sum / period;

    // إضافة أول قيمة EMA
    results.add(IndicatorValue(
      time: candles[period - 1].time,
      value: ema,
      indicatorId: indicatorId,
    ));

    // حساب بقية القيم
    for (int i = period; i < candles.length; i++) {
      ema = (candles[i].close - ema) * multiplier + ema;
      results.add(IndicatorValue(
        time: candles[i].time,
        value: ema,
        indicatorId: indicatorId,
      ));
    }

    // حفظ آخر قيمة
    _lastEma = ema;

    return results;
  }

  @override
  IndicatorValue? calculateSingle(Candle candle, List<Candle> previousCandles) {
    if (_lastEma == null) {
      // يجب حساب القيم الأولية أولاً
      final all = calculate([...previousCandles, candle]);
      return all.isNotEmpty ? all.last : null;
    }

    // الحساب التدريجي (أسرع)
    final multiplier = 2.0 / (period + 1);
    _lastEma = (candle.close - _lastEma!) * multiplier + _lastEma!;

    return IndicatorValue(
      time: candle.time,
      value: _lastEma!,
      indicatorId: indicatorId,
    );
  }

  /// إعادة تعيين الحالة
  void reset() {
    _lastEma = null;
  }

  /// الحصول على آخر قيمة
  double? get lastValue => _lastEma;
}
