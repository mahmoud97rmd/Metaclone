import 'package:equatable/equatable.dart';

class Candle extends Equatable {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final bool isComplete;
  final String instrument;

  const Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume = 0.0,
    this.isComplete = true,
    this.instrument = '',
  });

  bool get isBullish => close > open;
  bool get isBearish => close < open;
  
  double get bodySize => (close - open).abs();
  double get range => high - low;
  double get upperWick => isBullish ? high - close : high - open;
  double get lowerWick => isBullish ? open - low : close - low;

  @override
  List<Object?> get props => [
        time,
        open,
        high,
        low,
        close,
        volume,
        isComplete,
        instrument,
      ];

  Candle copyWith({
    DateTime? time,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
    bool? isComplete,
    String? instrument,
  }) {
    return Candle(
      time: time ?? this.time,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
      isComplete: isComplete ?? this.isComplete,
      instrument: instrument ?? this.instrument,
    );
  }
}
