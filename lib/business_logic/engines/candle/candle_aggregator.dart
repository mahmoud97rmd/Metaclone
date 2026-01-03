/// ═══════════════════════════════════════════════════════════
/// Candle Aggregator Engine
/// يحول Ticks (الأسعار اللحظية) إلى Candles (الشموع)
/// ═══════════════════════════════════════════════════════════

import 'dart:async';
import 'package:logger/logger.dart';

import '../../../core/constants/timeframe_constants.dart';
import '../../../domain/entities/tick.dart';
import '../../../domain/entities/candle.dart';

class CandleAggregator {
  final Logger _logger;
  final Timeframe timeframe;
  final String instrument;

  // الشمعة الحالية (التي لم تغلق بعد)
  Candle? _currentCandle;

  // Stream Controller لإصدار الشموع الجديدة
  final _candleController = StreamController<Candle>.broadcast();

  CandleAggregator({
    required Logger logger,
    required this.timeframe,
    required this.instrument,
  }) : _logger = logger;

  /// Stream الشموع المولدة
  Stream<Candle> get candleStream => _candleController.stream;

  /// إضافة Tick جديد
  void addTick(Tick tick) {
    // التحقق من أن الـ Tick للأداة الصحيحة
    if (tick.instrument != instrument) return;

    final tickTime = tick.time;
    final price = tick.mid;

    // حساب بداية الشمعة الحالية
    final candleStartTime = _getCandleStartTime(tickTime);

    if (_currentCandle == null) {
      // إنشاء شمعة جديدة
      _createNewCandle(candleStartTime, price);
      _logger.d('Created new candle at ${DateTime.fromMillisecondsSinceEpoch(candleStartTime)}');
    } else {
      // التحقق: هل ننتقل لشمعة جديدة؟
      if (candleStartTime > _currentCandle!.time) {
        // إغلاق الشمعة الحالية
        _closeCurrentCandle();

        // إنشاء شمعة جديدة
        _createNewCandle(candleStartTime, price);
        _logger.d('Candle closed and new candle created');
      } else {
        // تحديث الشمعة الحالية
        _updateCurrentCandle(price);
      }
    }
  }

  /// إنشاء شمعة جديدة
  void _createNewCandle(int time, double price) {
    _currentCandle = Candle(
      time: time,
      open: price,
      high: price,
      low: price,
      close: price,
      instrument: instrument,
      isComplete: false,
    );

    // إصدار الشمعة الحالية (غير مكتملة)
    _candleController.add(_currentCandle!);
  }

  /// تحديث الشمعة الحالية
  void _updateCurrentCandle(double price) {
    if (_currentCandle == null) return;

    _currentCandle = _currentCandle!.copyWith(
      high: price > _currentCandle!.high ? price : _currentCandle!.high,
      low: price < _currentCandle!.low ? price : _currentCandle!.low,
      close: price,
    );

    // إصدار التحديث
    _candleController.add(_currentCandle!);
  }

  /// إغلاق الشمعة الحالية
  void _closeCurrentCandle() {
    if (_currentCandle == null) return;

    // وضع علامة الإغلاق
    _currentCandle = _currentCandle!.copyWith(isComplete: true);

    // إصدار الشمعة المغلقة
    _candleController.add(_currentCandle!);

    _logger.i('Candle closed: ${_currentCandle!}');
  }

  /// حساب وقت بداية الشمعة بناءً على الـ Timeframe
  int _getCandleStartTime(DateTime tickTime) {
    final timestamp = tickTime.millisecondsSinceEpoch;
    final timeframeMs = timeframe.milliseconds;

    // تقريب إلى أقرب وقت بداية شمعة
    return (timestamp ~/ timeframeMs) * timeframeMs;
  }

  /// الحصول على الشمعة الحالية
  Candle? get currentCandle => _currentCandle;

  /// إغلاق يدوي (للتنظيف)
  void dispose() {
    if (_currentCandle != null && !_currentCandle!.isComplete) {
      _closeCurrentCandle();
    }
    _candleController.close();
  }
}
