import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../core/constants/timeframe_constants.dart';
import '../../../domain/entities/candle.dart';
import '../../../domain/entities/tick.dart';
import '../../../domain/usecases/market/get_historical_candles.dart';
import '../../../domain/usecases/market/subscribe_to_live_prices.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetHistoricalCandles getHistoricalCandles;
  final SubscribeToLivePrices subscribeToLivePrices;
  final Logger logger;

  StreamSubscription<dynamic>? _priceSubscription;

  ChartBloc({
    required this.getHistoricalCandles,
    required this.subscribeToLivePrices,
    required this.logger,
  }) : super(const ChartState()) {
    on<LoadCandles>(_onLoadCandles);
    on<ChangeInstrument>(_onChangeInstrument);
    on<ChangeTimeframe>(_onChangeTimeframe);
    on<UpdateLivePrice>(_onUpdateLivePrice);
  }

  Future<void> _onLoadCandles(LoadCandles event, Emitter<ChartState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await getHistoricalCandles(
      instrument: event.instrument,
      timeframe: event.timeframe,
      count: event.count,
    );

    result.fold(
      (failure) {
        logger.e('Failed to load candles: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (candles) {
        logger.i('Loaded ${candles.length} candles');
        emit(state.copyWith(
          isLoading: false,
          candles: candles,
          instrument: event.instrument,
          timeframe: event.timeframe,
        ));
      },
    );
  }

  Future<void> _onChangeInstrument(ChangeInstrument event, Emitter<ChartState> emit) async {
    emit(state.copyWith(instrument: event.instrument));
    add(LoadCandles(
      instrument: event.instrument,
      timeframe: state.timeframe,
      count: 500,
    ));
  }

  Future<void> _onChangeTimeframe(ChangeTimeframe event, Emitter<ChartState> emit) async {
    emit(state.copyWith(timeframe: event.timeframe));
    add(LoadCandles(
      instrument: state.instrument,
      timeframe: event.timeframe,
      count: 500,
    ));
  }

  void _onUpdateLivePrice(UpdateLivePrice event, Emitter<ChartState> emit) {
    if (state.candles.isEmpty) return;

    final updatedCandles = List<Candle>.from(state.candles);
    final lastCandle = updatedCandles.last;

    final updatedCandle = lastCandle.copyWith(
      close: event.tick.bid,
      high: lastCandle.high > event.tick.bid ? lastCandle.high : event.tick.bid,
      low: lastCandle.low < event.tick.bid ? lastCandle.low : event.tick.bid,
    );

    updatedCandles[updatedCandles.length - 1] = updatedCandle;

    emit(state.copyWith(
      candles: updatedCandles,
      currentPrice: event.tick.bid,
    ));
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    return super.close();
  }
}
