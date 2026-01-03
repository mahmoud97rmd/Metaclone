/// ═══════════════════════════════════════════════════════════
/// Get Account Info Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/account.dart';
import '../../repositories/trading_repository.dart';

class GetAccountInfo {
  final TradingRepository repository;

  GetAccountInfo(this.repository);

  Future<Either<Failure, Account>> call() async {
    return await repository.getAccountInfo();
  }
}
