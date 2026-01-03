/// ═══════════════════════════════════════════════════════════
/// Price DTO - OANDA Streaming Price Format
/// ═══════════════════════════════════════════════════════════
library;

import 'package:json_annotation/json_annotation.dart';
import '../../../models/tick_model.dart';

part 'price_dto.g.dart';

/// OANDA Price Stream Response
@JsonSerializable()
class OandaPriceDto {
  final String type;
  final String? time;
  final String? instrument;
  final List<OandaPriceBucketDto>? bids;
  final List<OandaPriceBucketDto>? asks;
  final String? closeoutBid;
  final String? closeoutAsk;
  final String? status;
  final bool? tradeable;

  OandaPriceDto({
    required this.type,
    this.time,
    this.instrument,
    this.bids,
    this.asks,
    this.closeoutBid,
    this.closeoutAsk,
    this.status,
    this.tradeable,
  });

  factory OandaPriceDto.fromJson(Map<String, dynamic> json) =>
      _$OandaPriceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaPriceDtoToJson(this);

  /// Convert to TickModel
  TickModel? toModel() {
    // تأكد من أن النوع هو "PRICE" وليس "HEARTBEAT"
    if (type != 'PRICE' || instrument == null || time == null) {
      return null;
    }

    final bid = bids?.isNotEmpty == true 
        ? double.parse(bids!.first.price) 
        : double.parse(closeoutBid ?? '0');
    
    final ask = asks?.isNotEmpty == true 
        ? double.parse(asks!.first.price) 
        : double.parse(closeoutAsk ?? '0');

    return TickModel(
      time: DateTime.parse(time!),
      bid: bid,
      ask: ask,
      instrument: instrument!,
    );
  }
}

@JsonSerializable()
class OandaPriceBucketDto {
  final String price;
  final int liquidity;

  OandaPriceBucketDto({
    required this.price,
    required this.liquidity,
  });

  factory OandaPriceBucketDto.fromJson(Map<String, dynamic> json) =>
      _$OandaPriceBucketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaPriceBucketDtoToJson(this);
}

/// Heartbeat (للحفاظ على الاتصال)
@JsonSerializable()
class OandaHeartbeatDto {
  final String type;
  final String time;

  OandaHeartbeatDto({
    required this.type,
    required this.time,
  });

  factory OandaHeartbeatDto.fromJson(Map<String, dynamic> json) =>
      _$OandaHeartbeatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaHeartbeatDtoToJson(this);
}
