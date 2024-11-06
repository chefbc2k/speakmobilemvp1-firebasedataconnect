import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:speakmobilemvp/core/routes/app_routes.dart';
import 'package:speakmobilemvp/core/config/environment.dart';
import 'package:speakmobilemvp/core/services/frontend/payment_service.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:speakmobilemvp/core/services/analytics/analytics_service.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Supabase
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );

  // Initialize Payment Service
  await PaymentService.initialize();

  // Initialize Recording Service
  final recordingService = RecordingService();
  
  // Request permissions on startup
  await recordingService.requestAllPermissions();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final analyticsService = AnalyticsService();
  
  runApp(MyApp(analyticsService: analyticsService));
}

class MyApp extends StatelessWidget {
  final AnalyticsService analyticsService;

  const MyApp({super.key, required this.analyticsService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ContractService>(
          create: (_) => ContractService(),
        ),
        // Add other providers here as needed
      ],
      child: MaterialApp(
        title: 'Speak Mobile MVP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.cardBackground,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimary,
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            color: AppColors.cardBackground,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: AppColors.cardBorder,
                width: 1,
              ),
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: AppColors.textPrimary),
            titleMedium: TextStyle(color: AppColors.textPrimary),
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textSecondary),
            bodySmall: TextStyle(color: AppColors.textMuted),
          ),
        ),
        initialRoute: AppRoutes.initial,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
