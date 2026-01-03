/// ═══════════════════════════════════════════════════════════
/// Base Indicator Calculator
/// الفئة الأساسية لجميع حاسبات المؤشرات
/// ═══════════════════════════════════════════════════════════

import '../../../domain/entities/candle.dart';

abstract class BaseIndicatorCalculator<T> {
  /// حساب المؤشر لجميع الشموع
  List<T> calculate(List<Candle> candles);

  /// حساب المؤشر لشمعة واحدة جديدة (تحديث تدريجي)
  T? calculateSingle(Candle candle, List<Candle> previousCandles);

  /// التحقق من صحة المعاملات
  bool validateParameters();
}
