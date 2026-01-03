/// ═══════════════════════════════════════════════════════════
/// Balance Chart
/// رسم بياني لتطور الرصيد (Placeholder)
/// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

class BalanceChart extends StatelessWidget {
  const BalanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'منحنى رأس المال',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              color: Colors.grey[900],
              child: const Center(
                child: Text('سيتم إضافة الرسم البياني قريباً'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
