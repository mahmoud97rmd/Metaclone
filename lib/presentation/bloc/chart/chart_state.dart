import 'package:equatable/equatable.dart';
import '../../../domain/entities/candle.dart';

abstract class ChartState extends Equatable {
  const ChartState();
  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}
class ChartLoading extends ChartState {}
class ChartLoaded extends ChartState {
  final List<Candle> candles;
  final String instrument;
  final String timeframe;
  const ChartLoaded(this.candles, this.instrument, this.timeframe);
  @override
  List<Object> get props => [candles, instrument, timeframe];
}
class ChartError extends ChartState {
  final String message;
  const ChartError(this.message);
  @override
  List<Object> get props => [message];
}
