/// ═══════════════════════════════════════════════════════════
/// Candle Model - Data Layer
/// يمتد من Candle Entity ويضيف JSON Serialization
/// ═══════════════════════════════════════════════════════════

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/candle.dart';

part 'candle_model.g.dart';

@JsonSerializable()
class CandleModel extends Candle {
  const CandleModel({
    required super.time,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.instrument,
    super.volume,
    super.isComplete,
  });

  /// من JSON (من API Response)
  factory CandleModel.fromJson(Map<String, dynamic> json) =>
      _$CandleModelFromJson(json);

  /// إلى JSON (للتخزين)
  Map<String, dynamic> toJson() => _$CandleModelToJson(this);

  /// من Entity
  factory CandleModel.fromEntity(Candle candle) {
    return CandleModel(
      time: candle.time,
      open: candle.open,
      high: candle.high,
      low: candle.low,
      close: candle.close,
      volume: candle.volume,
      isComplete: candle.isComplete,
      instrument: candle.instrument,
    );
  }

  /// إلى Entity
  Candle toEntity() {
    return Candle(
      time: time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
      isComplete: isComplete,
      instrument: instrument,
    );
  }

  @override
  CandleModel copyWith({
    int? time,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
    bool? isComplete,
    String? instrument,
  }) {
    return CandleModel(
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
