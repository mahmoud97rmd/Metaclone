/// ═══════════════════════════════════════════════════════════
/// Indicator Repository Interface
/// يحدد العقد لحساب المؤشرات الفنية
/// ═══════════════════════════════════════════════════════════
library;

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/candle.dart';
import '../entities/indicator.dart';

abstract class IndicatorRepository {
  /// حساب EMA (Exponential Moving Average)
  Future<Either<Failure, List<IndicatorValue>>> calculateEMA({
    required List<Candle> candles,
    required int period,
  });

  /// حساب SMA (Simple Moving Average)
  Future<Either<Failure, List<IndicatorValue>>> calculateSMA({
    required List<Candle> candles,
    required int period,
  });

  /// حساب RSI (Relative Strength Index)
  Future<Either<Failure, List<IndicatorValue>>> calculateRSI({
    required List<Candle> candles,
    required int period,
  });

  /// حساب Stochastic
  Future<Either<Failure, List<MultiLineIndicatorValue>>> calculateStochastic({
    required List<Candle> candles,
    required int kPeriod,
    required int dPeriod,
    required int slowing,
  });

  /// حفظ إعدادات المؤشر
  Future<Either<Failure, void>> saveIndicatorSettings({
    required Indicator indicator,
  });

  /// جلب إعدادات المؤشرات المحفوظة
  Future<Either<Failure, List<Indicator>>> getSavedIndicators();
}
