import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage secureStorage;
  final bool isLive;

  DioClient({
    required this.secureStorage,
    this.isLive = false,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.instance.token}',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<void> updateToken(String token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    await secureStorage.write(key: 'oanda_token', value: token);
  }
}
