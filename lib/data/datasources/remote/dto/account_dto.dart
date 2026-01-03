import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/account.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class OandaAccountResponse {
  final OandaAccountDto account;

  OandaAccountResponse({required this.account});

  factory OandaAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$OandaAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OandaAccountResponseToJson(this);
}

@JsonSerializable()
class OandaAccountDto {
  final String id;
  @JsonKey(name: 'NAV')
  final String nav;
  final String balance;
  final String marginUsed;
  final String marginAvailable;
  final String openTradeCount;
  final String openPositionCount;
  final String pendingOrderCount;
  final String pl;
  final String resettablePL;
  final String financing;
  final String commission;
  final String guaranteedExecutionFees;
  final String marginRate;

  OandaAccountDto({
    required this.id,
    required this.nav,
    required this.balance,
    required this.marginUsed,
    required this.marginAvailable,
    required this.openTradeCount,
    required this.openPositionCount,
    required this.pendingOrderCount,
    required this.pl,
    required this.resettablePL,
    required this.financing,
    required this.commission,
    required this.guaranteedExecutionFees,
    required this.marginRate,
  });

  factory OandaAccountDto.fromJson(Map<String, dynamic> json) =>
      _$OandaAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OandaAccountDtoToJson(this);

  Account toEntity() {
    final balanceValue = double.tryParse(balance) ?? 0.0;
    final equityValue = double.tryParse(nav) ?? 0.0;
    final usedMarginValue = double.tryParse(marginUsed) ?? 0.0;
    final freeMarginValue = double.tryParse(marginAvailable) ?? 0.0;
    final plValue = double.tryParse(pl) ?? 0.0;

    return Account(
      id: id,
      balance: balanceValue,
      equity: equityValue,
      usedMargin: usedMarginValue,
      freeMargin: freeMarginValue,
      marginLevel: usedMarginValue > 0 ? (equityValue / usedMarginValue) * 100 : 0,
      realizedPL: plValue,
      unrealizedPL: 0.0,
      currency: 'USD',
      lastUpdate: DateTime.now(),
    );
  }
}
