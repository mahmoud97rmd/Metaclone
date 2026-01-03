/// ═══════════════════════════════════════════════════════════
/// Close Trade Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/trade.dart';
import '../../repositories/trading_repository.dart';

class CloseTradeParams {
  final String tradeId;

  CloseTradeParams({required this.tradeId});
}

class CloseTrade {
  final TradingRepository repository;

  CloseTrade(this.repository);

  Future<Either<Failure, Trade>> call(CloseTradeParams params) async {
    return await repository.closeTrade(tradeId: params.tradeId);
  }
}
