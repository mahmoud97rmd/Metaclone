/// ═══════════════════════════════════════════════════════════
/// Calculate RSI Use Case
/// ═══════════════════════════════════════════════════════════
library;

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/candle.dart';
import '../../entities/indicator.dart';
import '../../repositories/indicator_repository.dart';

class RSIParams {
  final List<Candle> candles;
  final int period;

  RSIParams({
    required this.candles,
    required this.period,
  });
}

class CalculateRSI {
  final IndicatorRepository repository;

  CalculateRSI(this.repository);

  Future<Either<Failure, List<IndicatorValue>>> call(RSIParams params) async {
    return await repository.calculateRSI(
      candles: params.candles,
      period: params.period,
    );
  }
}
