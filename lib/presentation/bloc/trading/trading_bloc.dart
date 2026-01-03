/// ═══════════════════════════════════════════════════════════
/// Trading Bloc
/// ═══════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/repositories/trading_repository.dart';
import '../../../domain/usecases/trading/execute_trade.dart';
import '../../../domain/usecases/trading/close_trade.dart';
import '../../../domain/usecases/trading/get_account_info.dart';
import 'trading_event.dart';
import 'trading_state.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final ExecuteTrade executeTrade;
  final CloseTrade closeTrade;
  final GetAccountInfo getAccountInfo;
  final Logger logger;
  final TradingRepository tradingRepository;

  TradingBloc({
    required this.executeTrade,
    required this.closeTrade,
    required this.getAccountInfo,
    required this.logger,
    required this.tradingRepository,
  }) : super(TradingState.initial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
    on<LoadAccount>(_onLoadAccount);
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<TradingState> emit,
  ) async {
    emit(state.copyWith(status: TradingStatus.loading));

    final result = await executeTrade(ExecuteTradeParams(
      instrument: event.instrument,
      type: event.type,
      lotSize: event.lotSize,
      stopLoss: event.stopLoss,
      takeProfit: event.takeProfit,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: failure.message,
      )),
      (trade) {
        final updatedTrades = List.from(state.openTrades)..add(trade);
        emit(state.copyWith(
          status: TradingStatus.success,
          openTrades: updatedTrades,
        ));
      },
    );
  }

  Future<void> _onClosePosition(
    ClosePosition event,
    Emitter<TradingState> emit,
  ) async {
    final result = await closeTrade(CloseTradeParams(tradeId: event.tradeId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: failure.message,
      )),
      (trade) {
        final updatedTrades = state.openTrades
            .where((t) => t.id != event.tradeId)
            .toList();
        emit(state.copyWith(
          status: TradingStatus.success,
          openTrades: updatedTrades,
        ));
      },
    );
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<TradingState> emit,
  ) async {
    emit(state.copyWith(status: TradingStatus.loading));

    final result = await getAccountInfo();

    result.fold(
      (failure) => emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: failure.message,
      )),
      (account) => emit(state.copyWith(
        status: TradingStatus.success,
        account: account,
      )),
    );
  }
}
