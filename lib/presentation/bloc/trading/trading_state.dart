import 'package:equatable/equatable.dart';
import '../../../domain/entities/account.dart';

abstract class TradingState extends Equatable {
  const TradingState();
  @override
  List<Object> get props => [];
}

class TradingInitial extends TradingState {}
class TradingLoading extends TradingState {}
class TradingLoaded extends TradingState {
  final Account account;
  const TradingLoaded(this.account);
  @override
  List<Object> get props => [account];
}
class TradingError extends TradingState {
  final String message;
  const TradingError(this.message);
  @override
  List<Object> get props => [message];
}
