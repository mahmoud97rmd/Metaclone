// ═══════════════════════════════════════════════════════════
// Instrument Selector
// اختيار الأداة المالية
// ═══════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';

class InstrumentSelector extends StatelessWidget {
  final String selectedInstrument;
  final ValueChanged<String> onChanged;

  const InstrumentSelector({
    super.key,
    required this.selectedInstrument,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final instruments = [
      'XAU_USD', // Gold
      'EUR_USD',
      'GBP_USD',
      'USD_JPY',
      'USD_CHF',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedInstrument,
          dropdownColor: Theme.of(context).primaryColor,
          style: const TextStyle(color: Colors.white),
          items: instruments.map((instrument) {
            return DropdownMenuItem(
              value: instrument,
              child: Text(instrument),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
