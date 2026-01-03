import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/injection_container.dart';
import '../core/theme/app_theme.dart';
import '../domain/usecases/market/get_historical_candles.dart';
import '../domain/usecases/market/subscribe_to_live_prices.dart';
import '../domain/usecases/trading/execute_trade.dart';
import '../domain/usecases/trading/close_trade.dart';
import '../domain/usecases/trading/get_account_info.dart';
import '../presentation/bloc/chart/chart_bloc.dart';
import '../presentation/bloc/trading/trading_bloc.dart';
import '../presentation/pages/main_page.dart';

class MetaTraderApp extends StatelessWidget {
  const MetaTraderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChartBloc>(
          create: (context) => ChartBloc(
            getHistoricalCandles: getIt<GetHistoricalCandles>(),
            subscribeToLivePrices: getIt<SubscribeToLivePrices>(),
            logger: getIt(),
            marketRepository: getIt(),
          ),
        ),
        
        BlocProvider<TradingBloc>(
          create: (context) => TradingBloc(
            executeTrade: getIt<ExecuteTrade>(),
            closeTrade: getIt<CloseTrade>(),
            getAccountInfo: getIt<GetAccountInfo>(),
            logger: getIt(),
            tradingRepository: getIt(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'MetaTrader Clone',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainPage(),
      ),
    );
  }
}
