/// ═══════════════════════════════════════════════════════════
/// Subscribe to Live Prices Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/tick.dart';
import '../../repositories/market_repository.dart';

class LivePriceParams {
  final List<String> instruments;

  LivePriceParams({required this.instruments});
}

class SubscribeToLivePrices {
  final MarketRepository repository;

  SubscribeToLivePrices(this.repository);

  Stream<Either<Failure, Tick>> call(LivePriceParams params) {
    return repository.subscribeToLivePrices(instruments: params.instruments);
  }
}
