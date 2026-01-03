/// ═══════════════════════════════════════════════════════════
/// Trade Model
/// ═══════════════════════════════════════════════════════════

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/trade.dart';

part 'trade_model.g.dart';

@JsonSerializable()
class TradeModel extends Trade {
  const TradeModel({
    required super.id,
    required super.type,
    required super.instrument,
    required super.entryPrice,
    required super.lotSize,
    required super.openTime,
    super.exitPrice,
    super.closeTime,
    super.stopLoss,
    super.takeProfit,
    super.status,
    super.realizedProfitLoss,
    super.commission,
    super.swap,
    super.notes,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) =>
      _$TradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradeModelToJson(this);

  factory TradeModel.fromEntity(Trade trade) {
    return TradeModel(
      id: trade.id,
      type: trade.type,
      instrument: trade.instrument,
      entryPrice: trade.entryPrice,
      exitPrice: trade.exitPrice,
      lotSize: trade.lotSize,
      openTime: trade.openTime,
      closeTime: trade.closeTime,
      stopLoss: trade.stopLoss,
      takeProfit: trade.takeProfit,
      status: trade.status,
      realizedProfitLoss: trade.realizedProfitLoss,
      commission: trade.commission,
      swap: trade.swap,
      notes: trade.notes,
    );
  }

  Trade toEntity() {
    return Trade(
      id: id,
      type: type,
      instrument: instrument,
      entryPrice: entryPrice,
      exitPrice: exitPrice,
      lotSize: lotSize,
      openTime: openTime,
      closeTime: closeTime,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      status: status,
      realizedProfitLoss: realizedProfitLoss,
      commission: commission,
      swap: swap,
      notes: notes,
    );
  }
}
