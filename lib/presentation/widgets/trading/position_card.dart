import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/trade.dart';

class PositionCard extends StatelessWidget {
  final Trade trade;
  final VoidCallback onClose;

  const PositionCard({
    super.key,
    required this.trade,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.type == TradeType.buy;
    final profitLoss = trade.realizedProfitLoss ?? 0;
    final isProfit = profitLoss >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isBuy ? AppTheme.bullishColor.withOpacity(0.2) : AppTheme.bearishColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isBuy ? 'BUY' : 'SELL',
                        style: TextStyle(
                          color: isBuy ? AppTheme.bullishColor : AppTheme.bearishColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(trade.instrument, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _DetailItem(label: 'Volume', value: '${trade.lotSize.toStringAsFixed(2)} Lot')),
                Expanded(child: _DetailItem(label: 'Entry Price', value: trade.entryPrice.toStringAsFixed(5))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (trade.stopLoss != null)
                  Expanded(child: _DetailItem(label: 'SL', value: trade.stopLoss!.toStringAsFixed(5), color: AppTheme.bearishColor)),
                if (trade.takeProfit != null)
                  Expanded(child: _DetailItem(label: 'TP', value: trade.takeProfit!.toStringAsFixed(5), color: AppTheme.bullishColor)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profit/Loss:', style: TextStyle(fontSize: 14)),
                Text(
                  '$${profitLoss.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isProfit ? AppTheme.profitColor : AppTheme.lossColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Opened: ${DateFormat('yyyy-MM-dd HH:mm').format(trade.openTime)}',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _DetailItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
