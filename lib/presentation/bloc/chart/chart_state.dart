import 'package:equatable/equatable.dart';
import '../../../core/constants/timeframe_constants.dart';
import '../../../domain/entities/candle.dart';

enum ChartStatus {
  initial,
  loading,
  loaded,
  error,
}

class ChartState extends Equatable {
  final ChartStatus status;
  final List<Candle> candles;
  final String? instrument;
  final Timeframe? timeframe;
  final bool isLiveStreaming;
  final String? errorMessage;

  const ChartState({
    this.status = ChartStatus.initial,
    this.candles = const [],
    this.instrument,
    this.timeframe,
    this.isLiveStreaming = false,
    this.errorMessage,
  });

  factory ChartState.initial() {
    return const ChartState(
      status: ChartStatus.initial,
      candles: [],
      isLiveStreaming: false,
    );
  }

  ChartState copyWith({
    ChartStatus? status,
    List<Candle>? candles,
    String? instrument,
    Timeframe? timeframe,
    bool? isLiveStreaming,
    String? errorMessage,
  }) {
    return ChartState(
      status: status ?? this.status,
      candles: candles ?? this.candles,
      instrument: instrument ?? this.instrument,
      timeframe: timeframe ?? this.timeframe,
      isLiveStreaming: isLiveStreaming ?? this.isLiveStreaming,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        candles,
        instrument,
        timeframe,
        isLiveStreaming,
        errorMessage,
      ];
}
