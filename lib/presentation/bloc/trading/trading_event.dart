import 'package:equatable/equatable.dart';
import '../../../domain/entities/trade.dart';

abstract class TradingEvent extends Equatable {
  const TradingEvent();
  @override
  List<Object> get props => [];
}

class LoadAccount extends TradingEvent {}

class PlaceOrder extends TradingEvent {
  final String instrument;
  final double units;
  final TradeType type;
  final double? stopLoss;
  final double? takeProfit;

  const PlaceOrder({
    required this.instrument,
    required this.units,
    required this.type,
    this.stopLoss,
    this.takeProfit,
  });
  @override
  List<Object> get props => [instrument, units, type];
}

class ClosePosition extends TradingEvent {
  final String tradeId;
  const ClosePosition(this.tradeId);
  @override
  List<Object> get props => [tradeId];
}
