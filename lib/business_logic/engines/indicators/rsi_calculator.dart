/// ═══════════════════════════════════════════════════════════
/// RSI (Relative Strength Index) Calculator
/// مؤشر القوة النسبية
/// ═══════════════════════════════════════════════════════════

import 'dart:collection';
import '../../../domain/entities/candle.dart';
import '../../../domain/entities/indicator.dart';
import 'base_indicator_calculator.dart';

class RSICalculator extends BaseIndicatorCalculator<IndicatorValue> {
  final int period;
  final String indicatorId;

  // للحساب التدريجي
  double? _averageGain;
  double? _averageLoss;
  double? _previousClose;

  RSICalculator({
    required this.period,
    required this.indicatorId,
  });

  @override
  bool validateParameters() {
    return period > 0;
  }

  @override
  List<IndicatorValue> calculate(List<Candle> candles) {
    if (!validateParameters() || candles.length < period + 1) {
      return [];
    }

    final results = <IndicatorValue>[];
    final gains = <double>[];
    final losses = <double>[];

    // حساب التغيرات
    for (int i = 1; i < candles.length; i++) {
      final change = candles[i].close - candles[i - 1].close;
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    // حساب المتوسطات الأولية
    double avgGain = 0;
    double avgLoss = 0;
    for (int i = 0; i < period; i++) {
      avgGain += gains[i];
      avgLoss += losses[i];
    }
    avgGain /= period;
    avgLoss /= period;

    // حساب RSI الأول
    double rs = avgLoss != 0 ? avgGain / avgLoss : 0;
    double rsi = 100 - (100 / (1 + rs));

    results.add(IndicatorValue(
      time: candles[period].time,
      value: rsi,
      indicatorId: indicatorId,
    ));

    // حساب بقية القيم باستخدام Smoothed MA
    for (int i = period; i < gains.length; i++) {
      avgGain = (avgGain * (period - 1) + gains[i]) / period;
      avgLoss = (avgLoss * (period - 1) + losses[i]) / period;

      rs = avgLoss != 0 ? avgGain / avgLoss : 0;
      rsi = 100 - (100 / (1 + rs));

      results.add(IndicatorValue(
        time: candles[i + 1].time,
        value: rsi,
        indicatorId: indicatorId,
      ));
    }

    // حفظ القيم الأخيرة
    _averageGain = avgGain;
    _averageLoss = avgLoss;
    _previousClose = candles.last.close;

    return results;
  }

  @override
  IndicatorValue? calculateSingle(Candle candle, List<Candle> previousCandles) {
    if (_averageGain == null || _averageLoss == null || _previousClose == null) {
      // يجب حساب القيم الأولية
      final all = calculate([...previousCandles, candle]);
      return all.isNotEmpty ? all.last : null;
    }

    final change = candle.close - _previousClose!;
    final gain = change > 0 ? change : 0;
    final loss = change < 0 ? -change : 0;

    _averageGain = (_averageGain! * (period - 1) + gain) / period;
    _averageLoss = (_averageLoss! * (period - 1) + loss) / period;

    final rs = _averageLoss! != 0 ? _averageGain! / _averageLoss! : 0;
    final rsi = 100 - (100 / (1 + rs));

    _previousClose = candle.close;

    return IndicatorValue(
      time: candle.time,
      value: rsi,
      indicatorId: indicatorId,
    );
  }

  void reset() {
    _averageGain = null;
    _averageLoss = null;
    _previousClose = null;
  }
}
