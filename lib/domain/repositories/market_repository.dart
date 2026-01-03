/// ═══════════════════════════════════════════════════════════
/// Market Repository Interface
/// يحدد العقد (Contract) لجلب بيانات السوق
/// ═══════════════════════════════════════════════════════════
library;

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/constants/timeframe_constants.dart';
import '../entities/candle.dart';
import '../entities/tick.dart';

abstract class MarketRepository {
  /// جلب الشموع التاريخية
  /// 
  /// [instrument] - الأداة المالية (مثل: XAU_USD)
  /// [timeframe] - الإطار الزمني (M1, H1, etc.)
  /// [count] - عدد الشموع المطلوبة
  /// [from] - التاريخ الابتدائي (اختياري)
  /// [to] - التاريخ النهائي (اختياري)
  Future<Either<Failure, List<Candle>>> getHistoricalCandles({
    required String instrument,
    required Timeframe timeframe,
    int count = 500,
    DateTime? from,
    DateTime? to,
  });

  /// الاشتراك في البيانات الحية (Stream)
  /// 
  /// [instruments] - قائمة الأدوات المالية
  Stream<Either<Failure, Tick>> subscribeToLivePrices({
    required List<String> instruments,
  });

  /// الحصول على السعر الحالي (One-time)
  Future<Either<Failure, Tick>> getCurrentPrice({
    required String instrument,
  });

  /// جلب قائمة الأدوات المتاحة
  Future<Either<Failure, List<String>>> getAvailableInstruments();

  /// إيقاف الاشتراك في البيانات الحية
  Future<void> unsubscribeFromLivePrices();
}
