/// ═══════════════════════════════════════════════════════════
/// Calculate Stochastic Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/candle.dart';
import '../../entities/indicator.dart';
import '../../repositories/indicator_repository.dart';

class StochasticParams {
  final List<Candle> candles;
  final int kPeriod;
  final int dPeriod;
  final int slowing;

  StochasticParams({
    required this.candles,
    required this.kPeriod,
    required this.dPeriod,
    required this.slowing,
  });
}

class CalculateStochastic {
  final IndicatorRepository repository;

  CalculateStochastic(this.repository);

  Future<Either<Failure, List<MultiLineIndicatorValue>>> call(
    StochasticParams params,
  ) async {
    return await repository.calculateStochastic(
      candles: params.candles,
      kPeriod: params.kPeriod,
      dPeriod: params.dPeriod,
      slowing: params.slowing,
    );
  }
}
