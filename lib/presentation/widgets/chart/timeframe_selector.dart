/// ═══════════════════════════════════════════════════════════
/// Timeframe Selector
/// اختيار الإطار الزمني
/// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../core/constants/timeframe_constants.dart';

class TimeframeSelector extends StatelessWidget {
  final Timeframe selectedTimeframe;
  final ValueChanged<Timeframe> onChanged;

  const TimeframeSelector({
    super.key,
    required this.selectedTimeframe,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final timeframes = [
      Timeframe.m1,
      Timeframe.m5,
      Timeframe.m15,
      Timeframe.m30,
      Timeframe.h1,
      Timeframe.h4,
      Timeframe.d1,
    ];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timeframes.length,
        itemBuilder: (context, index) {
          final timeframe = timeframes[index];
          final isSelected = timeframe == selectedTimeframe;

          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InkWell(
              onTap: () => onChanged(timeframe),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  timeframe.code,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
