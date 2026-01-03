/// ═══════════════════════════════════════════════════════════
/// Oanda API Service - مبسط بدون Retrofit
/// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class OandaApiService {
  final Dio dio;
  final Logger logger;

  OandaApiService({
    required this.dio,
    required this.logger,
  });

  // ════════════════════════════════════════════════════════════
  // Market Data
  // ════════════════════════════════════════════════════════════

  Future<Response> getCandles({
    required String instrument,
    required String granularity,
    int? count,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'granularity': granularity,
        if (count != null) 'count': count,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      };

      final response = await dio.get(
        '/instruments/$instrument/candles',
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      logger.e('Error getting candles', error: e);
      rethrow;
    }
  }

  Future<Response> getCurrentPrice(String instrument) async {
    try {
      final response = await dio.get('/accounts/{accountId}/pricing',
          queryParameters: {'instruments': instrument});
      return response;
    } catch (e) {
      logger.e('Error getting price', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════════════
  // Trading
  // ════════════════════════════════════════════════════════════

  Future<Response> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await dio.post(
        '/accounts/{accountId}/orders',
        data: {'order': orderData},
      );
      return response;
    } catch (e) {
      logger.e('Error creating order', error: e);
      rethrow;
    }
  }

  Future<Response> closePosition(String instrument) async {
    try {
      final response = await dio.put(
        '/accounts/{accountId}/positions/$instrument/close',
        data: {'longUnits': 'ALL', 'shortUnits': 'ALL'},
      );
      return response;
    } catch (e) {
      logger.e('Error closing position', error: e);
      rethrow;
    }
  }

  Future<Response> getAccount() async {
    try {
      final response = await dio.get('/accounts/{accountId}');
      return response;
    } catch (e) {
      logger.e('Error getting account', error: e);
      rethrow;
    }
  }

  Future<Response> getOpenTrades() async {
    try {
      final response = await dio.get('/accounts/{accountId}/openTrades');
      return response;
    } catch (e) {
      logger.e('Error getting trades', error: e);
      rethrow;
    }
  }
}
