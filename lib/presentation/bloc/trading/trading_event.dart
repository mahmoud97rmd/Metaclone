import 'package:equatable/equatable.dart';
import '../../../domain/entities/trade.dart';

abstract class TradingEvent extends Equatable {
  const TradingEvent();
}

// Load Account Event
class LoadAccount extends TradingEvent {
  const LoadAccount();
  
  @override
  List<Object?> get props => [];
}

// Place Order Event
class PlaceOrder extends TradingEvent {
  final String instrument;
  final TradeType type;
  final double lotSize;
  final double? stopLoss;
  final double? takeProfit;

  const PlaceOrder({
    required this.instrument,
    required this.type,
    required this.lotSize,
    this.stopLoss,
    this.takeProfit,
  });

  @override
  List<Object?> get props => [instrument, type, lotSize, stopLoss, takeProfit];
}

// Close Position Event
class ClosePosition extends TradingEvent {
  final String tradeId;

  const ClosePosition({required this.tradeId});

  @override
  List<Object?> get props => [tradeId];
}

// Modify Position Event
class ModifyPosition extends TradingEvent {
  final String tradeId;
  final double? stopLoss;
  final double? takeProfit;

  const ModifyPosition({
    required this.tradeId,
    this.stopLoss,
    this.takeProfit,
  });

  @override
  List<Object?> get props => [tradeId, stopLoss, takeProfit];
}
