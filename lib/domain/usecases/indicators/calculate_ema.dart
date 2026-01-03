/// ═══════════════════════════════════════════════════════════
/// Calculate EMA Use Case
/// ═══════════════════════════════════════════════════════════
library;

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/candle.dart';
import '../../entities/indicator.dart';
import '../../repositories/indicator_repository.dart';

class EMAParams {
  final List<Candle> candles;
  final int period;

  EMAParams({
    required this.candles,
    required this.period,
  });
}

class CalculateEMA {
  final IndicatorRepository repository;

  CalculateEMA(this.repository);

  Future<Either<Failure, List<IndicatorValue>>> call(EMAParams params) async {
    return await repository.calculateEMA(
      candles: params.candles,
      period: params.period,
    );
  }
}
