/// ═══════════════════════════════════════════════════════════
/// Chart Widget
/// عرض الرسم البياني للشموع
/// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/timeframe_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/candle.dart';

class ChartWidget extends StatefulWidget {
  final List<Candle> candles;
  final String instrument;
  final Timeframe timeframe;

  const ChartWidget({
    super.key,
    required this.candles,
    required this.instrument,
    required this.timeframe,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  double _minPrice = 0;
  double _maxPrice = 0;

  @override
  void initState() {
    super.initState();
    _calculatePriceRange();
  }

  @override
  void didUpdateWidget(ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.candles != widget.candles) {
      _calculatePriceRange();
    }
  }

  void _calculatePriceRange() {
    if (widget.candles.isEmpty) return;

    _minPrice = widget.candles
        .map((c) => c.low)
        .reduce((a, b) => a < b ? a : b);
    
    _maxPrice = widget.candles
        .map((c) => c.high)
        .reduce((a, b) => a > b ? a : b);

    // إضافة هامش 2%
    final range = _maxPrice - _minPrice;
    _minPrice -= range * 0.02;
    _maxPrice += range * 0.02;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.candles.isEmpty) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    return Container(
      color: AppTheme.chartBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // معلومات السعر الحالي
          _buildPriceInfo(),
          
          const SizedBox(height: 8),
          
          // الرسم البياني
          Expanded(
            child: LineChart(
              _buildChartData(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    final lastCandle = widget.candles.last;
    final isGreen = lastCandle.close >= lastCandle.open;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.instrument,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.timeframe.name,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lastCandle.close.toStringAsFixed(5),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isGreen ? AppTheme.bullishColor : AppTheme.bearishColor,
                ),
              ),
              Text(
                'H: ${lastCandle.high.toStringAsFixed(5)} L: ${lastCandle.low.toStringAsFixed(5)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      minY: _minPrice,
      maxY: _maxPrice,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: (_maxPrice - _minPrice) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppTheme.gridColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppTheme.gridColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (widget.candles.length / 5).toDouble(),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.candles.length) {
                return const SizedBox.shrink();
              }
              
              final candle = widget.candles[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${candle.dateTime.hour}:${candle.dateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        _buildCandlestickLine(),
      ],
    );
  }

  LineChartBarData _buildCandlestickLine() {
    return LineChartBarData(
      spots: widget.candles.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.close);
      }).toList(),
      isCurved: false,
      color: AppTheme.accentColor,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: AppTheme.accentColor.withOpacity(0.1),
      ),
    );
  }
}
