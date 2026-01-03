/// ═══════════════════════════════════════════════════════════
/// Risk Calculator
/// حساب المخاطر وإدارة رأس المال
/// ═══════════════════════════════════════════════════════════

import 'dart:math';

class RiskCalculator {
  /// حساب حجم الصفقة بناءً على المخاطرة
  /// 
  /// [accountBalance] - رصيد الحساب
  /// [riskPercentage] - نسبة المخاطرة (مثال: 2.0 يعني 2%)
  /// [entryPrice] - سعر الدخول
  /// [stopLoss] - سعر Stop Loss
  /// [pipValue] - قيمة النقطة (Pip Value)
  /// 
  /// Returns: حجم الصفقة بالـ Lots
  static double calculateLotSize({
    required double accountBalance,
    required double riskPercentage,
    required double entryPrice,
    required double stopLoss,
    double pipValue = 10.0,
  }) {
    // المبلغ المعرض للخطر
    final riskAmount = accountBalance * (riskPercentage / 100);

    // المسافة بالنقاط
    final stopLossDistance = (entryPrice - stopLoss).abs();
    final stopLossPips = stopLossDistance * 10000; // للعملات

    if (stopLossPips == 0) return 0;

    // حساب حجم الصفقة
    final lotSize = riskAmount / (stopLossPips * pipValue);

    return lotSize;
  }

  /// حساب قيمة النقطة (Pip Value)
  /// 
  /// [lotSize] - حجم الصفقة
  /// [instrument] - الأداة المالية
  static double calculatePipValue({
    required double lotSize,
    required String instrument,
  }) {
    // للعملات الرئيسية
    if (!instrument.startsWith('XAU') && !instrument.startsWith('XAG')) {
      return lotSize * 10.0; // $10 لكل lot لكل pip
    }

    // للذهب
    if (instrument.startsWith('XAU')) {
      return lotSize * 1.0; // $1 لكل lot لكل $1 في السعر
    }

    // افتراضي
    return lotSize * 10.0;
  }

  /// حساب المارجن المطلوب
  /// 
  /// [lotSize] - حجم الصفقة
  /// [price] - السعر الحالي
  /// [leverage] - الرافعة المالية
  /// [instrument] - الأداة المالية
  static double calculateRequiredMargin({
    required double lotSize,
    required double price,
    required int leverage,
    required String instrument,
  }) {
    // حجم العقد
    final contractSize = instrument.startsWith('XAU') 
        ? 100.0  // 100 oz للذهب
        : 100000.0; // 100,000 وحدة للعملات

    // Margin = (Lot Size * Contract Size * Price) / Leverage
    return (lotSize * contractSize * price) / leverage;
  }

  /// حساب الربح/الخسارة المحتمل
  /// 
  /// [entryPrice] - سعر الدخول
  /// [targetPrice] - السعر المستهدف (TP أو SL)
  /// [lotSize] - حجم الصفقة
  /// [isBuy] - هل الصفقة شراء؟
  static double calculatePotentialPL({
    required double entryPrice,
    required double targetPrice,
    required double lotSize,
    required bool isBuy,
  }) {
    final priceDifference = isBuy 
        ? targetPrice - entryPrice 
        : entryPrice - targetPrice;

    final pips = priceDifference * 10000;
    return pips * lotSize * 10.0;
  }

  /// حساب Risk/Reward Ratio
  /// 
  /// [entryPrice] - سعر الدخول
  /// [stopLoss] - Stop Loss
  /// [takeProfit] - Take Profit
  /// [isBuy] - هل الصفقة شراء؟
  static double calculateRiskRewardRatio({
    required double entryPrice,
    required double stopLoss,
    required double takeProfit,
    required bool isBuy,
  }) {
    final risk = (entryPrice - stopLoss).abs();
    final reward = (takeProfit - entryPrice).abs();

    if (risk == 0) return 0;
    return reward / risk;
  }

  /// حساب Maximum Drawdown
  /// 
  /// [equityCurve] - منحنى رأس المال
  static double calculateMaxDrawdown(List<double> equityCurve) {
    if (equityCurve.length < 2) return 0;

    double maxDrawdown = 0;
    double peak = equityCurve.first;

    for (final equity in equityCurve) {
      if (equity > peak) {
        peak = equity;
      }

      final drawdown = ((peak - equity) / peak) * 100;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }

    return maxDrawdown;
  }

  /// حساب Sharpe Ratio
  /// 
  /// [returns] - قائمة العوائد
  /// [riskFreeRate] - معدل العائد الخالي من المخاطر
  static double calculateSharpeRatio({
    required List<double> returns,
    double riskFreeRate = 0.02, // 2% افتراضياً
  }) {
    if (returns.isEmpty) return 0;

    // حساب المتوسط
    final mean = returns.reduce((a, b) => a + b) / returns.length;

    // حساب الانحراف المعياري
    final variance = returns.fold<double>(
      0,
      (sum, r) => sum + pow(r - mean, 2),
    ) / returns.length;

    final stdDev = sqrt(variance);

    if (stdDev == 0) return 0;

    return (mean - riskFreeRate) / stdDev;
  }

  /// حساب Kelly Criterion (للتخصيص الأمثل لرأس المال)
  /// 
  /// [winRate] - نسبة الفوز (0-1)
  /// [avgWin] - متوسط الربح
  /// [avgLoss] - متوسط الخسارة
  static double calculateKellyCriterion({
    required double winRate,
    required double avgWin,
    required double avgLoss,
  }) {
    if (avgLoss == 0) return 0;

    final winLossRatio = avgWin / avgLoss;
    final kelly = (winRate * winLossRatio - (1 - winRate)) / winLossRatio;

    // تحديد الحد الأقصى عند 25% (للأمان)
    return kelly.clamp(0, 0.25);
  }

  /// التحقق من مستوى المارجن
  /// 
  /// [marginLevel] - مستوى المارجن (%)
  /// Returns: حالة الحساب
  static String getMarginStatus(double marginLevel) {
    if (marginLevel >= 200) return 'آمن';
    if (marginLevel >= 100) return 'تحذير';
    if (marginLevel >= 50) return 'Margin Call';
    return 'Stop Out';
  }

  /// حساب الحد الأقصى للصفقات المتزامنة
  /// 
  /// [accountBalance] - رصيد الحساب
  /// [riskPerTrade] - المخاطرة لكل صفقة
  /// [maxTotalRisk] - الحد الأقصى للمخاطرة الكلية
  static int calculateMaxConcurrentTrades({
    required double accountBalance,
    required double riskPerTrade,
    double maxTotalRisk = 10.0, // 10% حد أقصى
  }) {
    return (maxTotalRisk / riskPerTrade).floor();
  }
}
