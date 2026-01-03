/// ═══════════════════════════════════════════════════════════
/// Account Page
/// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/trading/trading_bloc.dart';
import '../bloc/trading/trading_state.dart';
import '../bloc/trading/trading_event.dart';
import '../widgets/account/account_summary_card.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<TradingBloc>().add(const LoadAccount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحساب'),
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
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'حدث خطأ',
                    textAlign: TextAlign.center,
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

          if (state.account == null) {
            return const Center(
              child: Text('لا توجد بيانات للحساب'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AccountSummaryCard(account: state.account!),
                const SizedBox(height: 16),
                // يمكن إضافة widgets أخرى هنا
              ],
            ),
          );
        },
      ),
    );
  }
}
