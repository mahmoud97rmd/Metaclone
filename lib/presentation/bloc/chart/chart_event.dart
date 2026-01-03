import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();
  @override
  List<Object> get props => [];
}

class LoadCandles extends ChartEvent {
  final String instrument;
  final String timeframe;
  final int count;
  const LoadCandles(this.instrument, this.timeframe, {this.count = 100});
  @override
  List<Object> get props => [instrument, timeframe, count];
}

class ChangeInstrument extends ChartEvent {
  final String instrument;
  const ChangeInstrument(this.instrument);
  @override
  List<Object> get props => [instrument];
}

class ChangeTimeframe extends ChartEvent {
  final String timeframe;
  const ChangeTimeframe(this.timeframe);
  @override
  List<Object> get props => [timeframe];
}

class UpdateLivePrice extends ChartEvent {
  final double price;
  const UpdateLivePrice(this.price);
  @override
  List<Object> get props => [price];
}
