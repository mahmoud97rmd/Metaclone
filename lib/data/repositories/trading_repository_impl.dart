import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/trade.dart';
import '../../domain/repositories/trading_repository.dart';
import '../datasources/local/simple_storage.dart';
import '../datasources/remote/oanda_api_service.dart';

class TradingRepositoryImpl implements TradingRepository {
  final OandaApiService apiService;
  final SimpleStorage storage;
  final NetworkInfo networkInfo;
  final Logger logger;

  final _accountController = StreamController<Either<Failure, Account>>.broadcast();

  TradingRepositoryImpl({
    required this.apiService,
    required this.storage,
    required this.networkInfo,
    required this.logger,
  });

  @override
  Future<Either<Failure, Trade>> executeTrade({
    required String instrument,
    required TradeType type,
    required double lotSize,
    double? stopLoss,
    double? takeProfit,
    String? notes,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final trade = Trade(
        id: 'trade_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        instrument: instrument,
        entryPrice: 2500.0,
        lotSize: lotSize,
        openTime: DateTime.now(),
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        status: TradeStatus.open,
        notes: notes,
      );

      logger.i('Trade executed: ${trade.id}');
      return Right(trade);
    } catch (e) {
      logger.e('Error executing trade', error: e);
      return Left(TradingFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Trade>> closeTrade({required String tradeId}) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      logger.i('Trade closed: $tradeId');
      return Right(Trade(
        id: tradeId,
        type: TradeType.buy,
        instrument: 'XAU_USD',
        entryPrice: 2500.0,
        exitPrice: 2510.0,
        lotSize: 1.0,
        openTime: DateTime.now().subtract(const Duration(hours: 1)),
        closeTime: DateTime.now(),
        status: TradeStatus.closed,
        realizedProfitLoss: 100.0,
      ));
    } catch (e) {
      logger.e('Error closing trade', error: e);
      return Left(TradingFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Trade>> modifyTrade({
    required String tradeId,
    double? stopLoss,
    double? takeProfit,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      logger.i('Trade modified: $tradeId');
      return Right(Trade(
        id: tradeId,
        type: TradeType.buy,
        instrument: 'XAU_USD',
        entryPrice: 2500.0,
        lotSize: 1.0,
        openTime: DateTime.now(),
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        status: TradeStatus.open,
      ));
    } catch (e) {
      logger.e('Error modifying trade', error: e);
      return Left(TradingFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Trade>>> getOpenTrades() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      return const Right([]);
    } catch (e) {
      logger.e('Error getting open trades', error: e);
      return Left(TradingFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Trade>>> getTradeHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      return const Right([]);
    } catch (e) {
      logger.e('Error getting trade history', error: e);
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> getAccountInfo() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final account = Account(
        id: 'account_123',
        balance: 10000.0,
        equity: 10000.0,
        usedMargin: 0.0,
        freeMargin: 10000.0,
        marginLevel: 0.0,
        realizedPL: 0.0,
        unrealizedPL: 0.0,
        currency: 'USD',
        lastUpdate: DateTime.now(),
      );

      return Right(account);
    } catch (e) {
      logger.e('Error getting account info', error: e);
      return Left(TradingFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Account>> watchAccount() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final result = await getAccountInfo();
      _accountController.add(result);
    });

    return _accountController.stream;
  }

  void dispose() {
    _accountController.close();
  }
}
