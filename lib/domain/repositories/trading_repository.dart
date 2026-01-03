import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/account.dart';
import '../entities/trade.dart';

abstract class TradingRepository {
  Future<Either<Failure, Trade>> executeTrade({
    required String instrument,
    required TradeType type,
    required double lotSize,
    double? stopLoss,
    double? takeProfit,
    String? notes,
  });

  Future<Either<Failure, Trade>> closeTrade({
    required String tradeId,
  });

  Future<Either<Failure, Trade>> modifyTrade({
    required String tradeId,
    double? stopLoss,
    double? takeProfit,
  });

  Future<Either<Failure, List<Trade>>> getOpenTrades();

  Future<Either<Failure, List<Trade>>> getTradeHistory({
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, Account>> getAccountInfo();

  Stream<Either<Failure, Account>> watchAccount();
}
