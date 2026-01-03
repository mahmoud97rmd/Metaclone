/// ═══════════════════════════════════════════════════════════
/// Dio Client
/// إعداد Dio للطلبات HTTP
/// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

class DioClient {
  final FlutterSecureStorage secureStorage;
  final bool isLive;
  late final Dio dio;

  DioClient({
    required this.secureStorage,
    this.isLive = false,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: isLive ? ApiConstants.liveBaseUrl : ApiConstants.practiceBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Datetime-Format': 'RFC3339',
        },
      ),
    );

    // إضافة Interceptors
    dio.interceptors.add(_AuthInterceptor(secureStorage));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }
}

/// Interceptor لإضافة Token تلقائياً
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  _AuthInterceptor(this.secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'api_token');
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Handle specific error cases
    handler.next(err);
  }
}
