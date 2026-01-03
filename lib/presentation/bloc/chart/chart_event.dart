/// ═══════════════════════════════════════════════════════════
/// Chart Events
/// ═══════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import '../../../core/constants/timeframe_constants.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل البيانات التاريخية
class LoadHistoricalData extends ChartEvent {
  final String instrument;
  final Timeframe timeframe;
  final int count;

  const LoadHistoricalData({
    required this.instrument,
    required this.timeframe,
    this.count = 500,
  });

  @override
  List<Object?> get props => [instrument, timeframe, count];
}

/// الاشتراك في البيانات الحية
class SubscribeToLiveData extends ChartEvent {
  final String instrument;

  const SubscribeToLiveData({required this.instrument});

  @override
  List<Object?> get props => [instrument];
}

/// إلغاء الاشتراك
class UnsubscribeFromLiveData extends ChartEvent {
  const UnsubscribeFromLiveData();
}

/// تغيير الإطار الزمني
class ChangeTimeframe extends ChartEvent {
  final Timeframe timeframe;

  const ChangeTimeframe({required this.timeframe});

  @override
  List<Object?> get props => [timeframe];
}

/// تحديث شمعة جديدة
class UpdateCandle extends ChartEvent {
  final dynamic candle; // سيكون Candle

  const UpdateCandle({required this.candle});

  @override
  List<Object?> get props => [candle];
}
