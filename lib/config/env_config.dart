/// Environment Configuration
/// IMPORTANT: Do NOT commit API keys to version control!
/// Use environment variables or a .env file in production.

class EnvConfig {
  // Grok API Key - Load from environment/secure storage in production
  // For development, you can set this value directly (but don't commit it!)
  static String get grokApiKey {
    // In production, use:
    // - String.fromEnvironment('GROK_API_KEY')
    // - Or load from secure storage
    // - Or use flutter_dotenv package
    
    const key = String.fromEnvironment('GROK_API_KEY', defaultValue: '');
    
    // DEVELOPMENT ONLY - Remove before committing!
    // return 'your_api_key_here';
    
    return key;
  }

  // Supabase Configuration (if not using supabase_flutter config)
  static String get supabaseUrl {
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    return url;
  }

  static String get supabaseAnonKey {
    const key = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    return key;
  }

  // OpenStreetMap Configuration
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmAttribution = '© OpenStreetMap contributors';

  // App Configuration
  static const String appName = 'MediNexus';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@medinexus.com';

  // Feature Flags
  static const bool enableFaceRecognition = false; // Mockup only for now
  static const bool enableVideoCall = true;
  static const bool enableAISymptomChecker = true;

  // API Endpoints (for additional services)
  static const String medicineApiBaseUrl = 'https://api.example.com/medicines';

  // Default Values
  static const int defaultConsultationDuration = 15; // minutes
  static const int maxAppointmentsPerDay = 50;
  static const double defaultConsultationFee = 500.0; // BDT
}

/// Secure Storage Keys
class StorageKeys {
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String themeMode = 'theme_mode';
  static const String language = 'language_preference';
  static const String fcmToken = 'fcm_token';
  static const String faceEncoding = 'face_encoding';
  static const String lastSyncTime = 'last_sync_time';
}

/// Route Names
class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String faceVerification = '/face-verification';
  
  // Patient Routes
  static const String patientHome = '/patient/home';
  static const String patientDashboard = '/patient/dashboard';
  static const String symptomChecker = '/patient/symptom-checker';
  static const String medicineRoutine = '/patient/medicine-routine';
  static const String appointments = '/patient/appointments';
  static const String prescriptions = '/patient/prescriptions';
  static const String vitals = '/patient/vitals';
  static const String findDoctor = '/patient/find-doctor';
  static const String bookAppointment = '/patient/book-appointment';
  
  // Doctor Routes
  static const String doctorHome = '/doctor/home';
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorSchedule = '/doctor/schedule';
  static const String doctorChambers = '/doctor/chambers';
  static const String doctorPatients = '/doctor/patients';
  static const String createPrescription = '/doctor/create-prescription';
  
  // Common Routes
  static const String chat = '/chat';
  static const String videoCall = '/video-call';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
}

/// Asset Paths
class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String logoLight = 'assets/images/logo_light.png';
  static const String doctorPlaceholder = 'assets/images/doctor_placeholder.png';
  static const String patientPlaceholder = 'assets/images/patient_placeholder.png';
  static const String emptyState = 'assets/images/empty_state.png';
  
  // Icons
  static const String iconDoctor = 'assets/icons/doctor.svg';
  static const String iconPatient = 'assets/icons/patient.svg';
  static const String iconStethoscope = 'assets/icons/stethoscope.svg';
  static const String iconPill = 'assets/icons/pill.svg';
  static const String iconCalendar = 'assets/icons/calendar.svg';
  static const String iconChat = 'assets/icons/chat.svg';
  static const String iconVideo = 'assets/icons/video.svg';
  
  // Lottie Animations
  static const String loadingAnimation = 'assets/lottie/loading.json';
  static const String successAnimation = 'assets/lottie/success.json';
  static const String errorAnimation = 'assets/lottie/error.json';
  static const String emptyAnimation = 'assets/lottie/empty.json';
  static const String healthAnimation = 'assets/lottie/health.json';
  static const String doctorAnimation = 'assets/lottie/doctor.json';
}
