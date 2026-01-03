/// ═══════════════════════════════════════════════════════════
/// Execute Trade Use Case
/// ═══════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/trade.dart';
import '../../repositories/trading_repository.dart';

class ExecuteTradeParams {
  final String instrument;
  final TradeType type;
  final double lotSize;
  final double? stopLoss;
  final double? takeProfit;
  final String? notes;

  ExecuteTradeParams({
    required this.instrument,
    required this.type,
    required this.lotSize,
    this.stopLoss,
    this.takeProfit,
    this.notes,
  });
}

class ExecuteTrade {
  final TradingRepository repository;

  ExecuteTrade(this.repository);

  Future<Either<Failure, Trade>> call(ExecuteTradeParams params) async {
    return await repository.executeTrade(
      instrument: params.instrument,
      type: params.type,
      lotSize: params.lotSize,
      stopLoss: params.stopLoss,
      takeProfit: params.takeProfit,
      notes: params.notes,
    );
  }
}
