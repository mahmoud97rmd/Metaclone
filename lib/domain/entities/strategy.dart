/// ═══════════════════════════════════════════════════════════
/// Strategy Entities
/// كيانات الاستراتيجيات والإشارات
/// ═══════════════════════════════════════════════════════════
library;

import 'package:equatable/equatable.dart';

/// Strategy Configuration
class StrategyConfig extends Equatable {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final bool isActive;

  const StrategyConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.parameters,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [id, name, description, parameters, isActive];
}

/// Trading Signal
enum SignalType { buy, sell, closeBuy, closeSell }

class TradingSignal extends Equatable {
  final SignalType type;
  final String instrument;
  final DateTime time;
  final double price;
  final String reason;
  final Map<String, dynamic>? metadata;

  const TradingSignal({
    required this.type,
    required this.instrument,
    required this.time,
    required this.price,
    required this.reason,
    this.metadata,
  });

  @override
  List<Object?> get props => [type, instrument, time, price, reason, metadata];
}

/// Backtest Result
class BacktestResult extends Equatable {
  final String strategyId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double totalProfit;
  final double totalLoss;
  final double netProfit;
  final double winRate;
  final double profitFactor;
  final double maxDrawdown;
  final double sharpeRatio;
  final List<double> equityCurve;

  const BacktestResult({
    required this.strategyId,
    required this.startDate,
    required this.endDate,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.totalProfit,
    required this.totalLoss,
    required this.netProfit,
    required this.winRate,
    required this.profitFactor,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.equityCurve,
  });

  @override
  List<Object?> get props => [
        strategyId,
        startDate,
        endDate,
        totalTrades,
        winningTrades,
        losingTrades,
        totalProfit,
        totalLoss,
        netProfit,
        winRate,
        profitFactor,
        maxDrawdown,
        sharpeRatio,
        equityCurve,
      ];
}
