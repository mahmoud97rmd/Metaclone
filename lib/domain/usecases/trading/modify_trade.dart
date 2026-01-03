/// ═══════════════════════════════════════════════════════════
/// Modify Trade Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/trade.dart';
import '../../repositories/trading_repository.dart';

class ModifyTradeParams {
  final String tradeId;
  final double? stopLoss;
  final double? takeProfit;

  ModifyTradeParams({
    required this.tradeId,
    this.stopLoss,
    this.takeProfit,
  });
}

class ModifyTrade {
  final TradingRepository repository;

  ModifyTrade(this.repository);

  Future<Either<Failure, Trade>> call(ModifyTradeParams params) async {
    return await repository.modifyTrade(
      tradeId: params.tradeId,
      stopLoss: params.stopLoss,
      takeProfit: params.takeProfit,
    );
  }
}
