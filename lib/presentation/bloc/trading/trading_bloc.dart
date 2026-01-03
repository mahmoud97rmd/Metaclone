import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/execute_trade.dart';
import '../../../domain/usecases/get_account_details.dart';
import '../../../domain/usecases/close_trade.dart';
import 'trading_event.dart';
import 'trading_state.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final GetAccountDetails getAccountDetails;
  final ExecuteTrade executeTrade;
  final CloseTrade closeTrade;

  TradingBloc({
    required this.getAccountDetails,
    required this.executeTrade,
    required this.closeTrade,
  }) : super(TradingInitial()) {
    on<LoadAccount>(_onLoadAccount);
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
  }

  Future<void> _onLoadAccount(LoadAccount event, Emitter<TradingState> emit) async {
    emit(TradingLoading());
    final result = await getAccountDetails();
    result.fold(
      (failure) => emit(TradingError(failure.message)),
      (account) => emit(TradingLoaded(account)),
    );
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<TradingState> emit) async {
    emit(TradingLoading());
    final result = await executeTrade(
      instrument: event.instrument,
      units: event.units,
      type: event.type,
      stopLoss: event.stopLoss,
      takeProfit: event.takeProfit,
    );
    result.fold(
      (failure) => emit(TradingError(failure.message)),
      (_) => add(LoadAccount()),
    );
  }

  Future<void> _onClosePosition(ClosePosition event, Emitter<TradingState> emit) async {
    final result = await closeTrade(tradeId: event.tradeId);
    result.fold(
      (failure) => emit(TradingError(failure.message)),
      (_) => add(LoadAccount()),
    );
  }
}
