/// ═══════════════════════════════════════════════════════════
/// Candle DTO - OANDA API Response Format
/// ═══════════════════════════════════════════════════════════
library;

import 'package:json_annotation/json_annotation.dart';
import '../../../models/candle_model.dart';

part 'candle_dto.g.dart';

/// OANDA Candles Response
@JsonSerializable()
class OandaCandlesResponse {
  final String instrument;
  final String granularity;
  final List<OandaCandleDto> candles;

  OandaCandlesResponse({
    required this.instrument,
    required this.granularity,
    required this.candles,
  });

  factory OandaCandlesResponse.fromJson(Map<String, dynamic> json) =>
      _$OandaCandlesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OandaCandlesResponseToJson(this);
}

/// OANDA Candle DTO
@JsonSerializable()
class OandaCandleDto {
  final String time;
  final int volume;
  final bool complete;
  final OandaCandleDataDto mid;
  final OandaCandleDataDto? bid;
  final OandaCandleDataDto? ask;

  OandaCandleDto({
    required this.time,
    required this.volume,
    required this.complete,
    required this.mid,
    this.bid,
    this.ask,
  });

  factory OandaCandleDto.fromJson(Map<String, dynamic> json) =>
      _$OandaCandleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaCandleDtoToJson(this);

  /// Convert to CandleModel
  CandleModel toModel(String instrument) {
    final dateTime = DateTime.parse(time);
    
    return CandleModel(
      time: dateTime.millisecondsSinceEpoch,
      open: double.parse(mid.o),
      high: double.parse(mid.h),
      low: double.parse(mid.l),
      close: double.parse(mid.c),
      volume: volume.toDouble(),
      isComplete: complete,
      instrument: instrument,
    );
  }
}

/// OANDA Candle Data (OHLC)
@JsonSerializable()
class OandaCandleDataDto {
  final String o; // Open
  final String h; // High
  final String l; // Low
  final String c; // Close

  OandaCandleDataDto({
    required this.o,
    required this.h,
    required this.l,
    required this.c,
  });

  factory OandaCandleDataDto.fromJson(Map<String, dynamic> json) =>
      _$OandaCandleDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaCandleDataDtoToJson(this);
}
