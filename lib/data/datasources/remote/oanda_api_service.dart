import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../core/config/app_config.dart';

class OandaApiService {
  final Dio dio;
  final Logger logger;

  OandaApiService({
    required this.dio,
    required this.logger,
  });

  String get accountId => AppConfig.instance.accountId;

  Future<Response> getAccount() async {
    logger.d('Getting account info for: $accountId');
    return await dio.get('/v3/accounts/$accountId');
  }

  Future<Response> getCandles({
    required String instrument,
    required String granularity,
    int? count,
    String? from,
    String? to,
  }) async {
    final queryParams = {
      'granularity': granularity,
      if (count != null) 'count': count.toString(),
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    };

    logger.d('Getting candles for $instrument');
    return await dio.get(
      '/v3/instruments/$instrument/candles',
      queryParameters: queryParams,
    );
  }

  Future<Response> getCurrentPrice(String instrument) async {
    logger.d('Getting current price for $instrument');
    return await dio.get(
      '/v3/accounts/$accountId/pricing',
      queryParameters: {'instruments': instrument},
    );
  }

  Future<Response> createOrder(Map<String, dynamic> orderData) async {
    logger.d('Creating order: $orderData');
    return await dio.post(
      '/v3/accounts/$accountId/orders',
      data: {'order': orderData},
    );
  }

  Future<Response> getOpenTrades() async {
    logger.d('Getting open trades');
    return await dio.get('/v3/accounts/$accountId/openTrades');
  }

  Future<Response> closeTrade(String tradeId) async {
    logger.d('Closing trade: $tradeId');
    return await dio.put('/v3/accounts/$accountId/trades/$tradeId/close');
  }
}
