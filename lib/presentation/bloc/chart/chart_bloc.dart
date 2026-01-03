import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_candles.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetCandles getCandles;

  ChartBloc({required this.getCandles}) : super(ChartInitial()) {
    on<LoadCandles>(_onLoadCandles);
    on<ChangeInstrument>(_onChangeInstrument);
    on<ChangeTimeframe>(_onChangeTimeframe);
    on<UpdateLivePrice>(_onUpdateLivePrice);
  }

  Future<void> _onLoadCandles(LoadCandles event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    final result = await getCandles(
      instrument: event.instrument,
      timeframe: event.timeframe,
      count: event.count,
    );
    result.fold(
      (failure) => emit(ChartError(failure.message)),
      (candles) => emit(ChartLoaded(candles, event.instrument, event.timeframe)),
    );
  }

  void _onChangeInstrument(ChangeInstrument event, Emitter<ChartState> emit) {
    if (state is ChartLoaded) {
      final currentState = state as ChartLoaded;
      add(LoadCandles(event.instrument, currentState.timeframe));
    } else {
      add(LoadCandles(event.instrument, 'H1'));
    }
  }

  void _onChangeTimeframe(ChangeTimeframe event, Emitter<ChartState> emit) {
    if (state is ChartLoaded) {
      final currentState = state as ChartLoaded;
      add(LoadCandles(currentState.instrument, event.timeframe));
    }
  }

  void _onUpdateLivePrice(UpdateLivePrice event, Emitter<ChartState> emit) {
    // Logic for live update would go here
  }
}
