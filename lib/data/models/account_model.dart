import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/account.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.balance,
    required super.equity,
    required super.usedMargin,
    required super.freeMargin,
    required super.marginLevel,
    required super.realizedPL,
    required super.unrealizedPL,
    required super.currency,
    required super.lastUpdate,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      id: account.id,
      balance: account.balance,
      equity: account.equity,
      usedMargin: account.usedMargin,
      freeMargin: account.freeMargin,
      marginLevel: account.marginLevel,
      realizedPL: account.realizedPL,
      unrealizedPL: account.unrealizedPL,
      currency: account.currency,
      lastUpdate: account.lastUpdate,
    );
  }
}
