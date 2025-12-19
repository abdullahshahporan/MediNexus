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
            home: const AppInitializer(),
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
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for auth provider to initialize
    final authProvider = context.read<AuthProvider>();
    
    // Wait until the auth provider is initialized
    while (!authProvider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const _SplashScreen();
    }

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

/// Splash screen shown during app initialization
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A), const Color(0xFF0A0A0A)]
                : [const Color(0xFFF8FAFC), const Color(0xFFFFFFFF), const Color(0xFFF8FAFC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // App Name
              Text(
                'MediNexus',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Healthcare at Your Fingertips',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: const Color(0xFF10B981),
                  backgroundColor: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
