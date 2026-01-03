import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trading/trading_bloc.dart';
import '../bloc/trading/trading_event.dart';
import '../bloc/trading/trading_state.dart';
import '../widgets/trading/position_card.dart';

class PositionsPage extends StatefulWidget {
  const PositionsPage({super.key});

  @override
  State<PositionsPage> createState() => _PositionsPageState();
}

class _PositionsPageState extends State<PositionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TradingBloc>().add(const LoadAccount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفقات المفتوحة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TradingBloc>().add(const LoadAccount());
            },
          ),
        ],
      ),
      body: BlocBuilder<TradingBloc, TradingState>(
        builder: (context, state) {
          if (state.status == TradingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TradingStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خطأ: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TradingBloc>().add(const LoadAccount());
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final openTrades = state.openTrades;

          if (openTrades.isEmpty) {
            return const Center(
              child: Text('لا توجد صفقات مفتوحة'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: openTrades.length,
            itemBuilder: (context, index) {
              final trade = openTrades[index];
              return PositionCard(
                trade: trade,
                onClose: () {
                  context.read<TradingBloc>().add(
                        ClosePosition(tradeId: trade.id),
                      );
                },
              );
            },
          );
        },
      ),
    );
  }
}
