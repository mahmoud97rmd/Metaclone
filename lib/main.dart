import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'app/di/injection_container.dart';
import 'presentation/bloc/chart/chart_bloc.dart';
import 'presentation/bloc/trading/trading_bloc.dart';
import 'presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize App Configuration
  await AppConfig.initialize();

  // Initialize Dependency Injection
  await configureDependencies();

  // Check if OANDA is configured
  if (!AppConfig.instance.isConfigured) {
    print('⚠️ WARNING: OANDA API is not configured properly!');
    print('Please add your credentials to .env file');
  } else {
    print('✅ OANDA API configured for: ${AppConfig.instance.environment}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChartBloc>(
          create: (context) => getIt<ChartBloc>(),
        ),
        BlocProvider<TradingBloc>(
          create: (context) => getIt<TradingBloc>(),
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
