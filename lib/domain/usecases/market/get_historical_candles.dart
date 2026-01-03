/// ═══════════════════════════════════════════════════════════
/// Get Historical Candles Use Case
/// ═══════════════════════════════════════════════════════════
library;

import 'package:dartz/dartz.dart';

import '../../../core/constants/timeframe_constants.dart';
import '../../../core/errors/failures.dart';
import '../../entities/candle.dart';
import '../../repositories/market_repository.dart';

class CandleParams {
  final String instrument;
  final Timeframe timeframe;
  final int count;
  final DateTime? from;
  final DateTime? to;

  CandleParams({
    required this.instrument,
    required this.timeframe,
    this.count = 500,
    this.from,
    this.to,
  });
}

class GetHistoricalCandles {
  final MarketRepository repository;

  GetHistoricalCandles(this.repository);

  Future<Either<Failure, List<Candle>>> call(CandleParams params) async {
    return await repository.getHistoricalCandles(
      instrument: params.instrument,
      timeframe: params.timeframe,
      count: params.count,
      from: params.from,
      to: params.to,
    );
  }
}
