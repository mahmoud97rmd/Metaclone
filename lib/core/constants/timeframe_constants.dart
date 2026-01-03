/// ═══════════════════════════════════════════════════════════
/// Timeframe Constants - الفترات الزمنية للشموع
/// ═══════════════════════════════════════════════════════════

enum Timeframe {
  /// 1 دقيقة
  m1('M1', 'M1', Duration(minutes: 1)),
  
  /// 5 دقائق
  m5('M5', 'M5', Duration(minutes: 5)),
  
  /// 15 دقيقة
  m15('M15', 'M15', Duration(minutes: 15)),
  
  /// 30 دقيقة
  m30('M30', 'M30', Duration(minutes: 30)),
  
  /// 1 ساعة
  h1('H1', 'H1', Duration(hours: 1)),
  
  /// 4 ساعات
  h4('H4', 'H4', Duration(hours: 4)),
  
  /// يومي
  d1('D', 'D', Duration(days: 1)),
  
  /// أسبوعي
  w1('W', 'W', Duration(days: 7)),
  
  /// شهري
  mn1('M', 'M', Duration(days: 30));

  const Timeframe(this.code, this.oandaGranularity, this.duration);
  
  /// الكود المختصر (للعرض)
  final String code;
  
  /// القيمة المستخدمة في OANDA API
  final String oandaGranularity;
  
  /// المدة الزمنية
  final Duration duration;
  
  /// الحصول على عدد الميلي ثانية
  int get milliseconds => duration.inMilliseconds;
  
  /// الحصول على عدد الثواني
  int get seconds => duration.inSeconds;
  
  /// هل هو إطار زمني دقائق؟
  bool get isMinuteBased => 
      this == m1 || this == m5 || this == m15 || this == m30;
  
  /// هل هو إطار زمني ساعات؟
  bool get isHourBased => this == h1 || this == h4;
  
  /// هل هو إطار زمني يومي أو أكبر؟
  bool get isDayBasedOrHigher => 
      this == d1 || this == w1 || this == mn1;
}

/// Extension methods للـ Timeframe
extension TimeframeExtension on Timeframe {
  /// Get display name in Arabic
  String get displayNameAr {
    switch (this) {
      case Timeframe.m1:
        return 'دقيقة واحدة';
      case Timeframe.m5:
        return '5 دقائق';
      case Timeframe.m15:
        return '15 دقيقة';
      case Timeframe.m30:
        return '30 دقيقة';
      case Timeframe.h1:
        return 'ساعة واحدة';
      case Timeframe.h4:
        return '4 ساعات';
      case Timeframe.d1:
        return 'يومي';
      case Timeframe.w1:
        return 'أسبوعي';
      case Timeframe.mn1:
        return 'شهري';
    }
  }
  
  /// Calculate number of candles in a given duration
  int candleCountForDuration(Duration duration) {
    return duration.inMilliseconds ~/ this.milliseconds;
  }
}
