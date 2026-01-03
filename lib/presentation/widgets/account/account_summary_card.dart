import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/account.dart';

class AccountSummaryCard extends StatelessWidget {
  final Account account;

  const AccountSummaryCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isProfit = account.profit >= 0;
    final profitPercentage = account.balance > 0 ? (account.profit / account.balance) * 100 : 0.0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Total Balance', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text('$${account.balance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Equity', value: '$${account.equity.toStringAsFixed(2)}', color: AppTheme.primaryColor),
                _StatItem(label: 'Profit', value: '$${account.profit.toStringAsFixed(2)}', color: isProfit ? AppTheme.profitColor : AppTheme.lossColor),
                _StatItem(label: 'Percent', value: '${profitPercentage.toStringAsFixed(2)}%', color: isProfit ? AppTheme.profitColor : AppTheme.lossColor),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MarginItem(label: 'Used Margin', value: account.margin),
                  _MarginItem(label: 'Free Margin', value: account.freeMargin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _MarginItem extends StatelessWidget {
  final String label;
  final double value;

  const _MarginItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Text('$${value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
