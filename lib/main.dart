/// ═══════════════════════════════════════════════════════════
/// Main Entry Point
/// نقطة الدخول الرئيسية للتطبيق
/// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'app/app.dart';
import 'app/di/injection_container.dart';

void main() async {
  // تأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تثبيت اتجاه الشاشة
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // إخفاء شريط الحالة
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  // تهيئة التبعيات
  await configureDependencies();

  final logger = getIt<Logger>();
  logger.i('🚀 Application starting...');

  // تشغيل التطبيق
  runApp(const MetaTraderApp());

  logger.i('✅ Application started successfully');
}
