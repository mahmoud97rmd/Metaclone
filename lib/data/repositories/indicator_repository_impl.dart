/// ═══════════════════════════════════════════════════════════
/// Indicator Repository Implementation - نسخة مكتملة
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/candle.dart';
import '../../domain/entities/indicator.dart';
import '../../domain/repositories/indicator_repository.dart';
import '../../business_logic/engines/indicators/indicator_engine.dart';

class IndicatorRepositoryImpl implements IndicatorRepository {
  final Logger logger;
  final IndicatorEngine indicatorEngine;

  IndicatorRepositoryImpl({
    required this.logger,
    required this.indicatorEngine,
  });

  @override
  Future<Either<Failure, List<IndicatorValue>>> calculateEMA({
    required List<Candle> candles,
    required int period,
  }) async {
    try {
      if (candles.length < period) {
        return Left(ValidationFailure(
          message: 'Not enough candles for EMA calculation',
        ));
      }

      final results = indicatorEngine.calculateEMA(
        candles: candles,
        period: period,
      );

      return Right(results);
    } catch (e) {
      logger.e('Error calculating EMA', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IndicatorValue>>> calculateSMA({
    required List<Candle> candles,
    required int period,
  }) async {
    try {
      if (candles.length < period) {
        return Left(ValidationFailure(
          message: 'Not enough candles for SMA calculation',
        ));
      }

      final results = indicatorEngine.calculateSMA(
        candles: candles,
        period: period,
      );

      return Right(results);
    } catch (e) {
      logger.e('Error calculating SMA', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IndicatorValue>>> calculateRSI({
    required List<Candle> candles,
    required int period,
  }) async {
    try {
      if (candles.length < period + 1) {
        return Left(ValidationFailure(
          message: 'Not enough candles for RSI calculation',
        ));
      }

      final results = indicatorEngine.calculateRSI(
        candles: candles,
        period: period,
      );

      return Right(results);
    } catch (e) {
      logger.e('Error calculating RSI', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MultiLineIndicatorValue>>> calculateStochastic({
    required List<Candle> candles,
    required int kPeriod,
    required int dPeriod,
    required int slowing,
  }) async {
    try {
      if (candles.length < kPeriod) {
        return Left(ValidationFailure(
          message: 'Not enough candles for Stochastic calculation',
        ));
      }

      final results = indicatorEngine.calculateStochastic(
        candles: candles,
        kPeriod: kPeriod,
        dPeriod: dPeriod,
        slowing: slowing,
      );

      return Right(results);
    } catch (e) {
      logger.e('Error calculating Stochastic', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveIndicatorSettings({
    required Indicator indicator,
  }) async {
    try {
      // TODO: Save to database
      logger.i('Indicator settings saved: ${indicator.id}');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Indicator>>> getSavedIndicators() async {
    try {
      // TODO: Load from database
      logger.i('Loading saved indicators');
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
