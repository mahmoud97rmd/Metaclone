import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/account.dart';

class AccountSummaryCard extends StatelessWidget {
  final Account account;
  const AccountSummaryCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isProfit = account.profit >= 0;
    final profitColor = isProfit ? AppTheme.profitColor : AppTheme.lossColor;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Balance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // تصحيح: إضافة باك سلاش قبل علامة الدولار
            Text('\$${account.balance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem('Equity', '\$${account.equity.toStringAsFixed(2)}', AppTheme.primaryColor),
                _buildItem('Profit', '\$${account.profit.toStringAsFixed(2)}', profitColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
