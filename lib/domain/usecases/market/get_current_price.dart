/// ═══════════════════════════════════════════════════════════
/// Get Current Price Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/tick.dart';
import '../../repositories/market_repository.dart';

class GetCurrentPrice {
  final MarketRepository repository;

  GetCurrentPrice(this.repository);

  Future<Either<Failure, Tick>> call(String instrument) async {
    return await repository.getCurrentPrice(instrument: instrument);
  }
}
