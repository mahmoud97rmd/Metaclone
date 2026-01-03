/// ═══════════════════════════════════════════════════════════
/// Exceptions - الاستثناءات المخصصة
/// تستخدم في Data Layer فقط
/// ═══════════════════════════════════════════════════════════

/// استثناء الخادم - عندما يفشل الطلب إلى API
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  const ServerException({
    required this.message,
    this.statusCode,
    this.response,
  });

  @override
  String toString() => 
      'ServerException: $message (Status: $statusCode)';
}

/// استثناء التخزين المحلي - عندما تفشل عمليات قاعدة البيانات
class CacheException implements Exception {
  final String message;
  final dynamic error;

  const CacheException({
    required this.message,
    this.error,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// استثناء الشبكة - عندما لا يوجد اتصال بالإنترنت
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'لا يوجد اتصال بالإنترنت',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// استثناء المصادقة - عندما تفشل عملية التحقق من API Token
class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException({
    this.message = 'فشل التحقق من الهوية',
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// استثناء التحليل - عندما يفشل تحليل JSON
class ParsingException implements Exception {
  final String message;
  final dynamic error;

  const ParsingException({
    required this.message,
    this.error,
  });

  @override
  String toString() => 'ParsingException: $message';
}

/// استثناء WebSocket
class WebSocketException implements Exception {
  final String message;
  final dynamic error;

  const WebSocketException({
    required this.message,
    this.error,
  });

  @override
  String toString() => 'WebSocketException: $message';
}

/// استثناء التحقق من البيانات
class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}
