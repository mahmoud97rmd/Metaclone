import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/trade.dart';

class PlaceOrderDialog extends StatefulWidget {
  final String instrument;
  final double currentPrice;

  const PlaceOrderDialog({
    super.key,
    required this.instrument,
    required this.currentPrice,
  });

  @override
  State<PlaceOrderDialog> createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends State<PlaceOrderDialog> {
  TradeType _tradeType = TradeType.buy;
  double _lotSize = 0.1;
  double? _stopLoss;
  double? _takeProfit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('فتح صفقة - ${widget.instrument}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // نوع الصفقة
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _tradeType = TradeType.buy),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tradeType == TradeType.buy
                          ? AppTheme.bullishColor
                          : Colors.grey,
                    ),
                    child: const Text('شراء'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _tradeType = TradeType.sell),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tradeType == TradeType.sell
                          ? AppTheme.bearishColor
                          : Colors.grey,
                    ),
                    child: const Text('بيع'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // السعر الحالي
            Text(
              'السعر الحالي: ${widget.currentPrice.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            
            // حجم العقد
            TextField(
              decoration: const InputDecoration(
                labelText: 'حجم العقد (Lot)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _lotSize = double.tryParse(value) ?? 0.1);
              },
              controller: TextEditingController(text: _lotSize.toString()),
            ),
            
            const SizedBox(height: 16),
            
            // Stop Loss
            TextField(
              decoration: const InputDecoration(
                labelText: 'Stop Loss (اختياري)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _stopLoss = double.tryParse(value));
              },
            ),
            
            const SizedBox(height: 16),
            
            // Take Profit
            TextField(
              decoration: const InputDecoration(
                labelText: 'Take Profit (اختياري)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() => _takeProfit = double.tryParse(value));
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'type': _tradeType,
              'lotSize': _lotSize,
              'stopLoss': _stopLoss,
              'takeProfit': _takeProfit,
            });
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
