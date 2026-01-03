import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/trade.dart';
import '../../../domain/usecases/trading/get_account_info.dart';
import '../../../domain/usecases/trading/execute_trade.dart';
import '../../../domain/usecases/trading/close_trade.dart';

part 'trading_event.dart';
part 'trading_state.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final GetAccountInfo getAccountInfo;
  final ExecuteTrade executeTrade;
  final CloseTrade closeTrade;
  final Logger logger;

  TradingBloc({
    required this.getAccountInfo,
    required this.executeTrade,
    required this.closeTrade,
    required this.logger,
  }) : super(const TradingState()) {
    on<LoadAccount>(_onLoadAccount);
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
  }

  Future<void> _onLoadAccount(LoadAccount event, Emitter<TradingState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await getAccountInfo();

    result.fold(
      (failure) {
        logger.e('Failed to load account: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (account) {
        logger.i('Account loaded: ${account.id}');
        emit(state.copyWith(
          isLoading: false,
          account: account,
          openTrades: const [],
        ));
      },
    );
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<TradingState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await executeTrade(
      instrument: event.instrument,
      units: event.units,
      type: event.type,
      stopLoss: event.stopLoss,
      takeProfit: event.takeProfit,
    );

    result.fold(
      (failure) {
        logger.e('Failed to place order: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (trade) {
        logger.i('Order placed: ${trade.id}');
        final updatedTrades = List<Trade>.from(state.openTrades)..add(trade);
        emit(state.copyWith(
          isLoading: false,
          openTrades: updatedTrades,
        ));
      },
    );
  }

  Future<void> _onClosePosition(ClosePosition event, Emitter<TradingState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await closeTrade(tradeId: event.tradeId);

    result.fold(
      (failure) {
        logger.e('Failed to close position: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (closedTrade) {
        logger.i('Position closed: ${closedTrade.id}');
        final updatedTrades = state.openTrades
            .where((t) => t.id != event.tradeId)
            .toList();
        emit(state.copyWith(
          isLoading: false,
          openTrades: updatedTrades,
        ));
      },
    );
  }
}
