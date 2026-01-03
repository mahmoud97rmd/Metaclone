/// ═══════════════════════════════════════════════════════════
/// Tick Model
/// ═══════════════════════════════════════════════════════════
library;

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tick.dart';

part 'tick_model.g.dart';

@JsonSerializable()
class TickModel extends Tick {
  const TickModel({
    required super.time,
    required super.bid,
    required super.ask,
    required super.instrument,
    super.last,
  });

  factory TickModel.fromJson(Map<String, dynamic> json) =>
      _$TickModelFromJson(json);

  Map<String, dynamic> toJson() => _$TickModelToJson(this);

  factory TickModel.fromEntity(Tick tick) {
    return TickModel(
      time: tick.time,
      bid: tick.bid,
      ask: tick.ask,
      instrument: tick.instrument,
      last: tick.last,
    );
  }

  Tick toEntity() {
    return Tick(
      time: time,
      bid: bid,
      ask: ask,
      instrument: instrument,
      last: last,
    );
  }
}
