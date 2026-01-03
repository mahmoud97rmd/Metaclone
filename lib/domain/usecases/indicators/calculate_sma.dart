/// ═══════════════════════════════════════════════════════════
/// Calculate SMA Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/candle.dart';
import '../../entities/indicator.dart';
import '../../repositories/indicator_repository.dart';

class SMAParams {
  final List<Candle> candles;
  final int period;

  SMAParams({
    required this.candles,
    required this.period,
  });
}

class CalculateSMA {
  final IndicatorRepository repository;

  CalculateSMA(this.repository);

  Future<Either<Failure, List<IndicatorValue>>> call(SMAParams params) async {
    return await repository.calculateSMA(
      candles: params.candles,
      period: params.period,
    );
  }
}
