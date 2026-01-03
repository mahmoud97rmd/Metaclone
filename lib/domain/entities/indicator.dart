/// ═══════════════════════════════════════════════════════════
/// Indicator Entity - المؤشرات الفنية
/// ═══════════════════════════════════════════════════════════
library;

import 'package:equatable/equatable.dart';

enum IndicatorType {
  ema('EMA', 'المتوسط المتحرك الأسي'),
  sma('SMA', 'المتوسط المتحرك البسيط'),
  rsi('RSI', 'مؤشر القوة النسبية'),
  macd('MACD', 'مؤشر الماكد'),
  stochastic('STOCHASTIC', 'مؤشر ستوكاستيك'),
  bollingerBands('BOLLINGER', 'بولينجر باند'),
  atr('ATR', 'متوسط المدى الحقيقي');

  const IndicatorType(this.code, this.displayName);
  final String code;
  final String displayName;
}

/// Base class for all indicators
abstract class Indicator extends Equatable {
  final IndicatorType type;
  final String id;
  final bool isVisible;
  final Map<String, dynamic> parameters;

  const Indicator({
    required this.type,
    required this.id,
    this.isVisible = true,
    required this.parameters,
  });

  @override
  List<Object?> get props => [type, id, isVisible, parameters];
}

/// EMA Indicator
class EMAIndicator extends Indicator {
  final int period;

  const EMAIndicator({
    required super.id,
    required this.period,
    super.isVisible,
  }) : super(
          type: IndicatorType.ema,
          parameters: const {},
        );

  @override
  String toString() => 'EMA($period)';
}

/// Stochastic Indicator
class StochasticIndicator extends Indicator {
  final int kPeriod;
  final int dPeriod;
  final int slowing;

  const StochasticIndicator({
    required super.id,
    required this.kPeriod,
    required this.dPeriod,
    required this.slowing,
    super.isVisible,
  }) : super(
          type: IndicatorType.stochastic,
          parameters: const {},
        );

  @override
  String toString() => 'Stochastic($kPeriod, $dPeriod, $slowing)';
}

/// Indicator Value (القيمة المحسوبة)
class IndicatorValue extends Equatable {
  final int time;
  final double value;
  final String indicatorId;

  const IndicatorValue({
    required this.time,
    required this.value,
    required this.indicatorId,
  });

  @override
  List<Object?> get props => [time, value, indicatorId];
}

/// Multi-line Indicator Value (لمؤشرات مثل Stochastic)
class MultiLineIndicatorValue extends Equatable {
  final int time;
  final Map<String, double> values;
  final String indicatorId;

  const MultiLineIndicatorValue({
    required this.time,
    required this.values,
    required this.indicatorId,
  });

  @override
  List<Object?> get props => [time, values, indicatorId];
}
