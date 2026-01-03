import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final double balance;
  final double equity;
  final double usedMargin;
  final double freeMargin;
  final double marginLevel;
  final double realizedPL;
  final double unrealizedPL;
  final String currency;
  final DateTime lastUpdate;

  const Account({
    required this.id,
    required this.balance,
    required this.equity,
    required this.usedMargin,
    required this.freeMargin,
    required this.marginLevel,
    required this.realizedPL,
    required this.unrealizedPL,
    required this.currency,
    required this.lastUpdate,
  });

  double get margin => usedMargin;
  double get profit => realizedPL + unrealizedPL;

  factory Account.empty() {
    return Account(
      id: '',
      balance: 0,
      equity: 0,
      usedMargin: 0,
      freeMargin: 0,
      marginLevel: 0,
      realizedPL: 0,
      unrealizedPL: 0,
      currency: 'USD',
      lastUpdate: DateTime.now(),
    );
  }

  Account copyWith({
    String? id,
    double? balance,
    double? equity,
    double? usedMargin,
    double? freeMargin,
    double? marginLevel,
    double? realizedPL,
    double? unrealizedPL,
    String? currency,
    DateTime? lastUpdate,
  }) {
    return Account(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      equity: equity ?? this.equity,
      usedMargin: usedMargin ?? this.usedMargin,
      freeMargin: freeMargin ?? this.freeMargin,
      marginLevel: marginLevel ?? this.marginLevel,
      realizedPL: realizedPL ?? this.realizedPL,
      unrealizedPL: unrealizedPL ?? this.unrealizedPL,
      currency: currency ?? this.currency,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        balance,
        equity,
        usedMargin,
        freeMargin,
        marginLevel,
        realizedPL,
        unrealizedPL,
        currency,
        lastUpdate,
      ];
}
