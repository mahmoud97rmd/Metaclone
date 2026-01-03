/// ═══════════════════════════════════════════════════════════
/// Chart Page - نسخة محدثة مع زر فتح صفقة
/// ═══════════════════════════════════════════════════════════
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/timeframe_constants.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';
import '../bloc/trading/trading_bloc.dart';
import '../bloc/trading/trading_event.dart';
import '../widgets/chart/chart_widget.dart';
import '../widgets/chart/timeframe_selector.dart';
import '../widgets/chart/instrument_selector.dart';
import '../widgets/trading/place_order_dialog.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _selectedInstrument = 'XAU_USD';
  Timeframe _selectedTimeframe = Timeframe.m15;

  @override
  void initState() {
    super.initState();
    _loadChart();
  }

  void _loadChart() {
    context.read<ChartBloc>().add(LoadHistoricalData(
          instrument: _selectedInstrument,
          timeframe: _selectedTimeframe,
          count: 500,
        ));
  }

  void _showPlaceOrderDialog() async {
    final chartState = context.read<ChartBloc>().state;
    
    if (chartState.candles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد بيانات للسعر الحالي')),
      );
      return;
    }

    final currentPrice = chartState.candles.last.close;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => PlaceOrderDialog(
        instrument: _selectedInstrument,
        currentPrice: currentPrice,
      ),
    );

    if (result != null && mounted) {
      context.read<TradingBloc>().add(PlaceOrder(
            instrument: _selectedInstrument,
            type: result['type'],
            lotSize: result['lotSize'],
            stopLoss: result['stopLoss'],
            takeProfit: result['takeProfit'],
          ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري تنفيذ الأمر...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرسم البياني'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChart,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الأدوات العلوي
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).secondaryHeaderColor,
            child: Row(
              children: [
                // اختيار الأداة المالية
                InstrumentSelector(
                  selectedInstrument: _selectedInstrument,
                  onChanged: (instrument) {
                    setState(() => _selectedInstrument = instrument);
                    _loadChart();
                  },
                ),
                const SizedBox(width: 8),
                
                // اختيار الإطار الزمني
                Expanded(
                  child: TimeframeSelector(
                    selectedTimeframe: _selectedTimeframe,
                    onChanged: (timeframe) {
                      setState(() => _selectedTimeframe = timeframe);
                      context.read<ChartBloc>().add(
                            ChangeTimeframe(timeframe: timeframe),
                          );
                    },
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // زر البث المباشر
                BlocBuilder<ChartBloc, ChartState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        state.isLiveStreaming 
                            ? Icons.stop_circle 
                            : Icons.play_circle,
                        color: state.isLiveStreaming 
                            ? Colors.red 
                            : Colors.green,
                      ),
                      onPressed: () {
                        if (state.isLiveStreaming) {
                          context.read<ChartBloc>().add(
                                const UnsubscribeFromLiveData(),
                              );
                        } else {
                          context.read<ChartBloc>().add(
                                SubscribeToLiveData(
                                  instrument: _selectedInstrument,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          
          // الرسم البياني
          Expanded(
            child: BlocBuilder<ChartBloc, ChartState>(
              builder: (context, state) {
                if (state.status == ChartStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.status == ChartStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'حدث خطأ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadChart,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state.candles.isEmpty) {
                  return const Center(
                    child: Text('لا توجد بيانات'),
                  );
                }
                
                return ChartWidget(
                  candles: state.candles,
                  instrument: state.instrument ?? '',
                  timeframe: state.timeframe ?? Timeframe.m15,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPlaceOrderDialog,
        icon: const Icon(Icons.add),
        label: const Text('أمر جديد'),
      ),
    );
  }
}
