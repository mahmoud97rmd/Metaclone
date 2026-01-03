import 'package:equatable/equatable.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/trade.dart';

enum TradingStatus {
  initial,
  loading,
  success,
  error,
}

class TradingState extends Equatable {
  final TradingStatus status;
  final Account? account;
  final List<Trade> openTrades;
  final List<Trade> closedTrades;
  final String? errorMessage;

  const TradingState({
    this.status = TradingStatus.initial,
    this.account,
    this.openTrades = const [],
    this.closedTrades = const [],
    this.errorMessage,
  });

  factory TradingState.initial() {
    return const TradingState(
      status: TradingStatus.initial,
      openTrades: [],
      closedTrades: [],
    );
  }

  TradingState copyWith({
    TradingStatus? status,
    Account? account,
    List<Trade>? openTrades,
    List<Trade>? closedTrades,
    String? errorMessage,
  }) {
    return TradingState(
      status: status ?? this.status,
      account: account ?? this.account,
      openTrades: openTrades ?? this.openTrades,
      closedTrades: closedTrades ?? this.closedTrades,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        account,
        openTrades,
        closedTrades,
        errorMessage,
      ];
}
