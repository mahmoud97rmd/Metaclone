/// ═══════════════════════════════════════════════════════════
/// Trade DTO - OANDA Trade Response
/// ═══════════════════════════════════════════════════════════

import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/trade.dart';
import '../../../models/trade_model.dart';

part 'trade_dto.g.dart';

@JsonSerializable()
class OandaTradesResponse {
  final List<OandaTradeDto> trades;

  OandaTradesResponse({required this.trades});

  factory OandaTradesResponse.fromJson(Map<String, dynamic> json) =>
      _$OandaTradesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OandaTradesResponseToJson(this);
}

@JsonSerializable()
class OandaTradeDto {
  final String id;
  final String instrument;
  final String price;
  final String openTime;
  final String state; // OPEN, CLOSED
  final String initialUnits; // positive = BUY, negative = SELL
  final String currentUnits;
  final String realizedPL;
  final String unrealizedPL;
  final String? stopLossOrder;
  final String? takeProfitOrder;

  OandaTradeDto({
    required this.id,
    required this.instrument,
    required this.price,
    required this.openTime,
    required this.state,
    required this.initialUnits,
    required this.currentUnits,
    required this.realizedPL,
    required this.unrealizedPL,
    this.stopLossOrder,
    this.takeProfitOrder,
  });

  factory OandaTradeDto.fromJson(Map<String, dynamic> json) =>
      _$OandaTradeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaTradeDtoToJson(this);

  /// Convert to TradeModel
  TradeModel toModel() {
    final units = double.parse(initialUnits);
    final isBuy = units > 0;
    
    return TradeModel(
      id: id,
      type: isBuy ? TradeType.buy : TradeType.sell,
      instrument: instrument,
      entryPrice: double.parse(price),
      lotSize: units.abs() / 100000, // تحويل Units إلى Lots
      openTime: DateTime.parse(openTime),
      status: state == 'OPEN' ? TradeStatus.open : TradeStatus.closed,
      realizedProfitLoss: double.parse(realizedPL),
      // TODO: Parse SL/TP from stopLossOrder/takeProfitOrder JSON
    );
  }
}
