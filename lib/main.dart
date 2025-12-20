import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'models/models.dart';
import 'pages/doctor/doctor_dashboard_page.dart';
import 'pages/intro_page.dart';
import 'pages/patient/patient_dashboard_page.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('No .env file found, using default config');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const MediNexusApp());
}

class MediNexusApp extends StatelessWidget {
  const MediNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, child) {
          // Update system UI overlay style based on theme
          SystemChrome.setSystemUIOverlayStyle(
            themeProvider.isDarkMode
                ? SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.transparent,
                  )
                : SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.transparent,
                  ),
          );

          return MaterialApp(
            title: 'MediNexus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: SplashScreen(
              nextScreen: const AppInitializer(),
            ),
          );
        },
      ),
    );
  }
}

/// Handles app initialization and determines the initial page
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          // Navigate to appropriate dashboard based on user role
          final role = authProvider.profile?.role;
          if (role == UserRole.doctor) {
            return const DoctorDashboardPage();
          }
          return const PatientDashboardPage();
        }
        return const IntroPage();
      },
    );
  }
}
