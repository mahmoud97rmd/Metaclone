/// ═══════════════════════════════════════════════════════════
/// Indicator Engine
/// محرك شامل لإدارة جميع المؤشرات
/// ═══════════════════════════════════════════════════════════

import 'package:logger/logger.dart';

import '../../../domain/entities/candle.dart';
import '../../../domain/entities/indicator.dart';
import 'ema_calculator.dart';
import 'sma_calculator.dart';
import 'rsi_calculator.dart';
import 'stochastic_calculator.dart';

class IndicatorEngine {
  final Logger _logger;

  // Map للمحافظة على حالة المؤشرات
  final Map<String, dynamic> _calculators = {};

  IndicatorEngine({required Logger logger}) : _logger = logger;

  /// حساب EMA
  List<IndicatorValue> calculateEMA({
    required List<Candle> candles,
    required int period,
    String? indicatorId,
  }) {
    final id = indicatorId ?? 'EMA_$period';
    
    if (!_calculators.containsKey(id)) {
      _calculators[id] = EMACalculator(
        period: period,
        indicatorId: id,
      );
    }

    final calculator = _calculators[id] as EMACalculator;
    return calculator.calculate(candles);
  }

  /// حساب SMA
  List<IndicatorValue> calculateSMA({
    required List<Candle> candles,
    required int period,
    String? indicatorId,
  }) {
    final id = indicatorId ?? 'SMA_$period';
    
    if (!_calculators.containsKey(id)) {
      _calculators[id] = SMACalculator(
        period: period,
        indicatorId: id,
      );
    }

    final calculator = _calculators[id] as SMACalculator;
    return calculator.calculate(candles);
  }

  /// حساب RSI
  List<IndicatorValue> calculateRSI({
    required List<Candle> candles,
    required int period,
    String? indicatorId,
  }) {
    final id = indicatorId ?? 'RSI_$period';
    
    if (!_calculators.containsKey(id)) {
      _calculators[id] = RSICalculator(
        period: period,
        indicatorId: id,
      );
    }

    final calculator = _calculators[id] as RSICalculator;
    return calculator.calculate(candles);
  }

  /// حساب Stochastic
  List<MultiLineIndicatorValue> calculateStochastic({
    required List<Candle> candles,
    required int kPeriod,
    required int dPeriod,
    required int slowing,
    String? indicatorId,
  }) {
    final id = indicatorId ?? 'STOCH_${kPeriod}_${dPeriod}_$slowing';
    
    if (!_calculators.containsKey(id)) {
      _calculators[id] = StochasticCalculator(
        kPeriod: kPeriod,
        dPeriod: dPeriod,
        slowing: slowing,
        indicatorId: id,
      );
    }

    final calculator = _calculators[id] as StochasticCalculator;
    return calculator.calculate(candles);
  }

  /// إعادة تعيين مؤشر محدد
  void resetIndicator(String indicatorId) {
    if (_calculators.containsKey(indicatorId)) {
      final calculator = _calculators[indicatorId];
      if (calculator is EMACalculator) {
        calculator.reset();
      } else if (calculator is SMACalculator) {
        calculator.reset();
      } else if (calculator is RSICalculator) {
        calculator.reset();
      } else if (calculator is StochasticCalculator) {
        calculator.reset();
      }
    }
  }

  /// إعادة تعيين جميع المؤشرات
  void resetAll() {
    _calculators.clear();
    _logger.i('All indicators reset');
  }

  /// Dispose
  void dispose() {
    _calculators.clear();
  }
}
