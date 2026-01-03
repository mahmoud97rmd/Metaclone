/// ═══════════════════════════════════════════════════════════
/// Chart Bloc
/// ═══════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/repositories/market_repository.dart';
import '../../../domain/usecases/market/get_historical_candles.dart';
import '../../../domain/usecases/market/subscribe_to_live_prices.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetHistoricalCandles getHistoricalCandles;
  final SubscribeToLivePrices subscribeToLivePrices;
  final Logger logger;
  final MarketRepository marketRepository;

  StreamSubscription? _priceSubscription;

  ChartBloc({
    required this.getHistoricalCandles,
    required this.subscribeToLivePrices,
    required this.logger,
    required this.marketRepository,
  }) : super(ChartState.initial()) {
    on<LoadHistoricalData>(_onLoadHistoricalData);
    on<ChangeTimeframe>(_onChangeTimeframe);
    on<SubscribeToLiveData>(_onSubscribeToLiveData);
    on<UnsubscribeFromLiveData>(_onUnsubscribeFromLiveData);
  }

  Future<void> _onLoadHistoricalData(
    LoadHistoricalData event,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(status: ChartStatus.loading));

    final result = await getHistoricalCandles(CandleParams(
      instrument: event.instrument,
      timeframe: event.timeframe,
      count: event.count,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChartStatus.error,
        errorMessage: failure.message,
      )),
      (candles) => emit(state.copyWith(
        status: ChartStatus.loaded,
        candles: candles,
        instrument: event.instrument,
        timeframe: event.timeframe,
      )),
    );
  }

  Future<void> _onChangeTimeframe(
    ChangeTimeframe event,
    Emitter<ChartState> emit,
  ) async {
    if (state.instrument != null) {
      add(LoadHistoricalData(
        instrument: state.instrument!,
        timeframe: event.timeframe,
        count: 500,
      ));
    }
  }

  Future<void> _onSubscribeToLiveData(
    SubscribeToLiveData event,
    Emitter<ChartState> emit,
  ) async {
    await _priceSubscription?.cancel();

    final stream = subscribeToLivePrices(
      LivePriceParams(instruments: [event.instrument]),
    );

    _priceSubscription = stream.listen(
      (result) {
        result.fold(
          (failure) => add(const UnsubscribeFromLiveData()),
          (tick) {
            // Update last candle with new price
            if (state.candles.isNotEmpty) {
              final updatedCandles = List.from(state.candles);
              // Logic to update last candle
              emit(state.copyWith(candles: updatedCandles));
            }
          },
        );
      },
    );

    emit(state.copyWith(isLiveStreaming: true));
  }

  Future<void> _onUnsubscribeFromLiveData(
    UnsubscribeFromLiveData event,
    Emitter<ChartState> emit,
  ) async {
    await _priceSubscription?.cancel();
    emit(state.copyWith(isLiveStreaming: false));
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    return super.close();
  }
}
