import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language_preference';
  
  String _currentLanguage = 'en'; // 'en' or 'bn' for Bangla
  SharedPreferences? _prefs;

  String get currentLanguage => _currentLanguage;
  bool get isBangla => _currentLanguage == 'bn';
  bool get isEnglish => _currentLanguage == 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLanguage = _prefs?.getString(_languageKey);
    
    if (savedLanguage != null) {
      _currentLanguage = savedLanguage;
      notifyListeners();
    }
  }

  Future<void> toggleLanguage() async {
    _currentLanguage = _currentLanguage == 'en' ? 'bn' : 'en';
    await _prefs?.setString(_languageKey, _currentLanguage);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (language != _currentLanguage) {
      _currentLanguage = language;
      await _prefs?.setString(_languageKey, _currentLanguage);
      notifyListeners();
    }
  }

  // Translations
  String translate(String key) {
    return _translations[key]?[_currentLanguage] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    // Intro Page
    'app_title': {
      'en': 'MediNexus',
      'bn': 'মেডিনেক্সাস',
    },
    'app_subtitle': {
      'en': 'Healthcare at Your Fingertips',
      'bn': 'আপনার হাতের মুঠোয় স্বাস্থ্যসেবা',
    },
    'select_role': {
      'en': 'Select Your Role',
      'bn': 'আপনার ভূমিকা নির্বাচন করুন',
    },
    'patient': {
      'en': 'Patient',
      'bn': 'রোগী',
    },
    'patient_desc': {
      'en': 'Book appointments and manage health',
      'bn': 'অ্যাপয়েন্টমেন্ট বুক করুন এবং স্বাস্থ্য পরিচালনা করুন',
    },
    'doctor': {
      'en': 'Doctor',
      'bn': 'ডাক্তার',
    },
    'doctor_desc': {
      'en': 'Manage appointments and patients',
      'bn': 'অ্যাপয়েন্টমেন্ট এবং রোগী পরিচালনা করুন',
    },
    'terms_privacy': {
      'en': 'By continuing, you agree to our Terms & Privacy Policy',
      'bn': 'চালিয়ে যাওয়ার মাধ্যমে, আপনি আমাদের শর্তাবলী এবং গোপনীয়তা নীতিতে সম্মত হন',
    },
    
    // Sign In Page
    'welcome_back': {
      'en': 'Welcome Back',
      'bn': 'স্বাগতম',
    },
    'sign_in_as': {
      'en': 'Sign in as',
      'bn': 'লগইন করুন',
    },
    'email': {
      'en': 'Email',
      'bn': 'ইমেইল',
    },
    'enter_email': {
      'en': 'Enter your email',
      'bn': 'আপনার ইমেইল লিখুন',
    },
    'password': {
      'en': 'Password',
      'bn': 'পাসওয়ার্ড',
    },
    'enter_password': {
      'en': 'Enter your password',
      'bn': 'আপনার পাসওয়ার্ড লিখুন',
    },
    'forgot_password': {
      'en': 'Forgot Password?',
      'bn': 'পাসওয়ার্ড ভুলে গেছেন?',
    },
    'sign_in': {
      'en': 'Sign In',
      'bn': 'লগইন',
    },
    'signing_in': {
      'en': 'Signing In...',
      'bn': 'লগইন হচ্ছে...',
    },
    'or': {
      'en': 'OR',
      'bn': 'অথবা',
    },
    'no_account': {
      'en': 'Don\'t have an account? ',
      'bn': 'অ্যাকাউন্ট নেই? ',
    },
    'create_account': {
      'en': 'Create Account',
      'bn': 'অ্যাকাউন্ট তৈরি করুন',
    },
    
    // Sign Up Page
    'create_account_title': {
      'en': 'Create Account',
      'bn': 'অ্যাকাউন্ট তৈরি করুন',
    },
    'join_as': {
      'en': 'Join as',
      'bn': 'যোগদান করুন',
    },
    'personal_info': {
      'en': 'Personal Information',
      'bn': 'ব্যক্তিগত তথ্য',
    },
    'full_name': {
      'en': 'Full Name',
      'bn': 'পুরো নাম',
    },
    'enter_name': {
      'en': 'Enter your full name',
      'bn': 'আপনার পুরো নাম লিখুন',
    },
    'age': {
      'en': 'Age',
      'bn': 'বয়স',
    },
    'enter_age': {
      'en': 'Enter your age',
      'bn': 'আপনার বয়স লিখুন',
    },
    'gender': {
      'en': 'Gender',
      'bn': 'লিঙ্গ',
    },
    'select_gender': {
      'en': 'Select gender',
      'bn': 'লিঙ্গ নির্বাচন করুন',
    },
    'male': {
      'en': 'Male',
      'bn': 'পুরুষ',
    },
    'female': {
      'en': 'Female',
      'bn': 'মহিলা',
    },
    'other': {
      'en': 'Other',
      'bn': 'অন্যান্য',
    },
    'blood_group': {
      'en': 'Blood Group',
      'bn': 'রক্তের গ্রুপ',
    },
    'select_blood_group': {
      'en': 'Select blood group',
      'bn': 'রক্তের গ্রুপ নির্বাচন করুন',
    },
    'contact_info': {
      'en': 'Contact Information',
      'bn': 'যোগাযোগের তথ্য',
    },
    'mobile': {
      'en': 'Mobile Number',
      'bn': 'মোবাইল নম্বর',
    },
    'enter_mobile': {
      'en': 'Enter mobile number',
      'bn': 'মোবাইল নম্বর লিখুন',
    },
    'enter_email_address': {
      'en': 'Enter email address',
      'bn': 'ইমেইল ঠিকানা লিখুন',
    },
    'address': {
      'en': 'Address',
      'bn': 'ঠিকানা',
    },
    'enter_address': {
      'en': 'Enter your address',
      'bn': 'আপনার ঠিকানা লিখুন',
    },
    'security': {
      'en': 'Security',
      'bn': 'নিরাপত্তা',
    },
    'create_password': {
      'en': 'Create a password',
      'bn': 'পাসওয়ার্ড তৈরি করুন',
    },
    'confirm_password': {
      'en': 'Confirm Password',
      'bn': 'পাসওয়ার্ড নিশ্চিত করুন',
    },
    'confirm_password_hint': {
      'en': 'Confirm your password',
      'bn': 'আপনার পাসওয়ার্ড নিশ্চিত করুন',
    },
    'agree_terms': {
      'en': 'I agree to Terms & Privacy Policy',
      'bn': 'আমি শর্তাবলী এবং গোপনীয়তা নীতিতে সম্মত',
    },
    'creating_account': {
      'en': 'Creating Account...',
      'bn': 'অ্যাকাউন্ট তৈরি হচ্ছে...',
    },
    'have_account': {
      'en': 'Already have an account? ',
      'bn': 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
    },
    
    // Home Page
    'welcome': {
      'en': 'Welcome back,',
      'bn': 'স্বাগতম,',
    },
    'logged_in_as': {
      'en': 'Logged in as',
      'bn': 'লগইন করেছেন',
    },
    'auth_success': {
      'en': 'Authentication Successful!',
      'bn': 'প্রমাণীকরণ সফল!',
    },
    'logged_into': {
      'en': 'You are now logged into MediNexus',
      'bn': 'আপনি এখন মেডিনেক্সাসে লগইন করেছেন',
    },
    'sign_out': {
      'en': 'Sign Out',
      'bn': 'লগআউট',
    },
    'sign_out_confirm': {
      'en': 'Are you sure you want to sign out?',
      'bn': 'আপনি কি লগআউট করতে চান?',
    },
    'cancel': {
      'en': 'Cancel',
      'bn': 'বাতিল',
    },
    
    // Validation Messages
    'please_enter_name': {
      'en': 'Please enter your name',
      'bn': 'অনুগ্রহ করে আপনার নাম লিখুন',
    },
    'please_enter_age': {
      'en': 'Please enter your age',
      'bn': 'অনুগ্রহ করে আপনার বয়স লিখুন',
    },
    'please_select_gender': {
      'en': 'Please select your gender',
      'bn': 'অনুগ্রহ করে আপনার লিঙ্গ নির্বাচন করুন',
    },
    'please_select_blood_group': {
      'en': 'Please select your blood group',
      'bn': 'অনুগ্রহ করে আপনার রক্তের গ্রুপ নির্বাচন করুন',
    },
    'please_enter_mobile': {
      'en': 'Please enter your mobile number',
      'bn': 'অনুগ্রহ করে আপনার মোবাইল নম্বর লিখুন',
    },
    'please_enter_email': {
      'en': 'Please enter your email',
      'bn': 'অনুগ্রহ করে আপনার ইমেইল লিখুন',
    },
    'valid_email': {
      'en': 'Please enter a valid email',
      'bn': 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন',
    },
    'please_enter_address': {
      'en': 'Please enter your address',
      'bn': 'অনুগ্রহ করে আপনার ঠিকানা লিখুন',
    },
    'please_enter_password': {
      'en': 'Please enter a password',
      'bn': 'অনুগ্রহ করে একটি পাসওয়ার্ড লিখুন',
    },
    'password_length': {
      'en': 'Password must be at least 6 characters',
      'bn': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
    },
    'password_confirm': {
      'en': 'Please confirm your password',
      'bn': 'অনুগ্রহ করে আপনার পাসওয়ার্ড নিশ্চিত করুন',
    },
    'password_match': {
      'en': 'Passwords do not match',
      'bn': 'পাসওয়ার্ড মিলছে না',
    },
    'agree_terms_required': {
      'en': 'Please agree to Terms & Privacy Policy',
      'bn': 'অনুগ্রহ করে শর্তাবলী এবং গোপনীয়তা নীতিতে সম্মত হন',
    },
    
    // Enhanced Auth Pages
    'sign_in_continue': {
      'en': 'Sign in to continue to your account',
      'bn': 'আপনার অ্যাকাউন্টে চালিয়ে যেতে সাইন ইন করুন',
    },
    'doctor_portal': {
      'en': 'Doctor Portal',
      'bn': 'ডাক্তার পোর্টাল',
    },
    'patient_portal': {
      'en': 'Patient Portal',
      'bn': 'রোগী পোর্টাল',
    },
    'remember_me': {
      'en': 'Remember me',
      'bn': 'আমাকে মনে রাখুন',
    },
    'sign_in_face_id': {
      'en': 'Sign in with Face ID',
      'bn': 'ফেস আইডি দিয়ে সাইন ইন করুন',
    },
    'or_continue_with': {
      'en': 'or continue with',
      'bn': 'অথবা চালিয়ে যান',
    },
    'scanning_face': {
      'en': 'Scanning Face...',
      'bn': 'মুখ স্ক্যান করা হচ্ছে...',
    },
    'position_face': {
      'en': 'Position your face in the frame',
      'bn': 'ফ্রেমে আপনার মুখ রাখুন',
    },
    'sign_up': {
      'en': 'Sign Up',
      'bn': 'সাইন আপ',
    },
    'continue': {
      'en': 'Continue',
      'bn': 'চালিয়ে যান',
    },
    'step_1_desc': {
      'en': 'Enter your basic information',
      'bn': 'আপনার মৌলিক তথ্য লিখুন',
    },
    'step_2_desc': {
      'en': 'Create a secure password',
      'bn': 'একটি নিরাপদ পাসওয়ার্ড তৈরি করুন',
    },
    'step_3_desc': {
      'en': 'Professional details for verification',
      'bn': 'যাচাইয়ের জন্য পেশাদার তথ্য',
    },
    'secure_account': {
      'en': 'Secure Your Account',
      'bn': 'আপনার অ্যাকাউন্ট সুরক্ষিত করুন',
    },
    'professional_info': {
      'en': 'Professional Information',
      'bn': 'পেশাদার তথ্য',
    },
    'mobile_number': {
      'en': 'Mobile Number',
      'bn': 'মোবাইল নম্বর',
    },
    're_enter_password': {
      'en': 'Re-enter your password',
      'bn': 'আপনার পাসওয়ার্ড পুনরায় লিখুন',
    },
    'password_min_length': {
      'en': 'Password must be at least 6 characters',
      'bn': 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
    },
    'passwords_not_match': {
      'en': 'Passwords do not match',
      'bn': 'পাসওয়ার্ড মিলছে না',
    },
    'i_agree_to': {
      'en': 'I agree to the',
      'bn': 'আমি সম্মত',
    },
    'terms_conditions': {
      'en': 'Terms & Conditions',
      'bn': 'শর্তাবলী',
    },
    'and': {
      'en': 'and',
      'bn': 'এবং',
    },
    'privacy_policy': {
      'en': 'Privacy Policy',
      'bn': 'গোপনীয়তা নীতি',
    },
    'specialization': {
      'en': 'Specialization',
      'bn': 'বিশেষজ্ঞতা',
    },
    'enter_specialization': {
      'en': 'e.g., Cardiologist, Dermatologist',
      'bn': 'যেমন, হৃদরোগ বিশেষজ্ঞ, চর্মরোগ বিশেষজ্ঞ',
    },
    'please_enter_specialization': {
      'en': 'Please enter your specialization',
      'bn': 'অনুগ্রহ করে আপনার বিশেষজ্ঞতা লিখুন',
    },
    'qualification': {
      'en': 'Qualification',
      'bn': 'যোগ্যতা',
    },
    'enter_qualification': {
      'en': 'e.g., MBBS, MD, FCPS',
      'bn': 'যেমন, এমবিবিএস, এমডি, এফসিপিএস',
    },
    'please_enter_qualification': {
      'en': 'Please enter your qualification',
      'bn': 'অনুগ্রহ করে আপনার যোগ্যতা লিখুন',
    },
    'experience_years': {
      'en': 'Experience (Years)',
      'bn': 'অভিজ্ঞতা (বছর)',
    },
    'years': {
      'en': 'Years',
      'bn': 'বছর',
    },
    'consultation_fee': {
      'en': 'Consultation Fee',
      'bn': 'পরামর্শ ফি',
    },
    'bmdc_number': {
      'en': 'BMDC Registration No.',
      'bn': 'বিএমডিসি নিবন্ধন নং',
    },
    'enter_bmdc': {
      'en': 'Enter your BMDC number',
      'bn': 'আপনার বিএমডিসি নম্বর লিখুন',
    },
    
    // Forgot Password
    'forgot_password_title': {
      'en': 'Forgot Password?',
      'bn': 'পাসওয়ার্ড ভুলে গেছেন?',
    },
    'forgot_password_desc': {
      'en': 'Enter your email address and we\'ll send you a link to reset your password.',
      'bn': 'আপনার ইমেইল ঠিকানা লিখুন এবং আমরা পাসওয়ার্ড রিসেট করার লিঙ্ক পাঠাব।',
    },
    'send_reset_link': {
      'en': 'Send Reset Link',
      'bn': 'রিসেট লিঙ্ক পাঠান',
    },
    'back_to_sign_in': {
      'en': 'Back to Sign In',
      'bn': 'সাইন ইন-এ ফিরে যান',
    },
    'email_sent_title': {
      'en': 'Check Your Email',
      'bn': 'আপনার ইমেইল চেক করুন',
    },
    'email_sent_desc': {
      'en': 'We\'ve sent a password reset link to your email address.',
      'bn': 'আমরা আপনার ইমেইল ঠিকানায় পাসওয়ার্ড রিসেট লিঙ্ক পাঠিয়েছি।',
    },
    'didnt_receive_email': {
      'en': 'Didn\'t receive the email? Try again',
      'bn': 'ইমেইল পাননি? আবার চেষ্টা করুন',
    },
    
    // Dashboard Common
    'home': {
      'en': 'Home',
      'bn': 'হোম',
    },
    'appointments': {
      'en': 'Appointments',
      'bn': 'অ্যাপয়েন্টমেন্ট',
    },
    'health': {
      'en': 'Health',
      'bn': 'স্বাস্থ্য',
    },
    'profile': {
      'en': 'Profile',
      'bn': 'প্রোফাইল',
    },
    'dashboard': {
      'en': 'Dashboard',
      'bn': 'ড্যাশবোর্ড',
    },
    'schedule': {
      'en': 'Schedule',
      'bn': 'সময়সূচী',
    },
    'patients': {
      'en': 'Patients',
      'bn': 'রোগী',
    },
    'good_morning': {
      'en': 'Good Morning',
      'bn': 'সুপ্রভাত',
    },
    'good_afternoon': {
      'en': 'Good Afternoon',
      'bn': 'শুভ অপরাহ্ন',
    },
    'good_evening': {
      'en': 'Good Evening',
      'bn': 'শুভ সন্ধ্যা',
    },
    'today': {
      'en': 'Today',
      'bn': 'আজ',
    },
    'upcoming': {
      'en': 'Upcoming',
      'bn': 'আসন্ন',
    },
    'completed': {
      'en': 'Completed',
      'bn': 'সম্পন্ন',
    },
    'cancelled': {
      'en': 'Cancelled',
      'bn': 'বাতিল',
    },
    'search': {
      'en': 'Search',
      'bn': 'অনুসন্ধান',
    },
    'notifications': {
      'en': 'Notifications',
      'bn': 'বিজ্ঞপ্তি',
    },
    'settings': {
      'en': 'Settings',
      'bn': 'সেটিংস',
    },
    'view_all': {
      'en': 'View All',
      'bn': 'সব দেখুন',
    },
    'no_appointments': {
      'en': 'No appointments yet',
      'bn': 'এখনও কোনো অ্যাপয়েন্টমেন্ট নেই',
    },
    'book_appointment': {
      'en': 'Book Appointment',
      'bn': 'অ্যাপয়েন্টমেন্ট বুক করুন',
    },
    
    // Quick Actions
    'find_doctor': {
      'en': 'Find Doctor',
      'bn': 'ডাক্তার খুঁজুন',
    },
    'symptom_checker': {
      'en': 'Symptom Checker',
      'bn': 'লক্ষণ পরীক্ষক',
    },
    'medicine_routine': {
      'en': 'Medicine Routine',
      'bn': 'ওষুধের রুটিন',
    },
    'health_records': {
      'en': 'Health Records',
      'bn': 'স্বাস্থ্য রেকর্ড',
    },
    'chat': {
      'en': 'Chat',
      'bn': 'চ্যাট',
    },
    'video_call': {
      'en': 'Video Call',
      'bn': 'ভিডিও কল',
    },
    
    // Doctor Dashboard
    'online_status': {
      'en': 'Online Status',
      'bn': 'অনলাইন স্ট্যাটাস',
    },
    'go_online': {
      'en': 'Go Online',
      'bn': 'অনলাইনে যান',
    },
    'go_offline': {
      'en': 'Go Offline',
      'bn': 'অফলাইনে যান',
    },
    'today_appointments': {
      'en': 'Today\'s Appointments',
      'bn': 'আজকের অ্যাপয়েন্টমেন্ট',
    },
    'pending_requests': {
      'en': 'Pending Requests',
      'bn': 'মুলতুবি অনুরোধ',
    },
    'total_patients': {
      'en': 'Total Patients',
      'bn': 'মোট রোগী',
    },
    'earnings_today': {
      'en': 'Today\'s Earnings',
      'bn': 'আজকের আয়',
    },
    'in_person': {
      'en': 'In-Person',
      'bn': 'সরাসরি',
    },
    'online': {
      'en': 'Online',
      'bn': 'অনলাইন',
    },
    'chamber': {
      'en': 'Chamber',
      'bn': 'চেম্বার',
    },
    'select_chamber': {
      'en': 'Select Chamber',
      'bn': 'চেম্বার নির্বাচন করুন',
    },
    'available_slots': {
      'en': 'Available Slots',
      'bn': 'উপলব্ধ স্লট',
    },
    'booked': {
      'en': 'Booked',
      'bn': 'বুক হয়েছে',
    },
    'available': {
      'en': 'Available',
      'bn': 'উপলব্ধ',
    },
    
    // Language Settings
    'languageCode': {
      'en': 'en',
      'bn': 'bn',
    },
    
    // Chat/Messaging
    'messages': {
      'en': 'Messages',
      'bn': 'বার্তা',
    },
    'conversations': {
      'en': 'conversations',
      'bn': 'কথোপকথন',
    },
    'search_conversations': {
      'en': 'Search conversations...',
      'bn': 'কথোপকথন অনুসন্ধান করুন...',
    },
    'no_messages': {
      'en': 'No messages yet',
      'bn': 'এখনও কোনো বার্তা নেই',
    },
    'no_messages_desc': {
      'en': 'Start a conversation with your doctor',
      'bn': 'আপনার ডাক্তারের সাথে একটি কথোপকথন শুরু করুন',
    },
    'type_message': {
      'en': 'Type a message...',
      'bn': 'একটি বার্তা লিখুন...',
    },
    
    // Symptom Checker
    'ai_powered_analysis': {
      'en': 'AI-Powered Health Analysis',
      'bn': 'এআই-চালিত স্বাস্থ্য বিশ্লেষণ',
    },
    'symptom_disclaimer': {
      'en': 'This is not a medical diagnosis. Please consult a healthcare professional for proper medical advice.',
      'bn': 'এটি কোনো চিকিৎসা নির্ণয় নয়। সঠিক চিকিৎসা পরামর্শের জন্য একজন স্বাস্থ্যসেবা পেশাদারের সাথে পরামর্শ করুন।',
    },
    'enter_symptom': {
      'en': 'Enter a symptom...',
      'bn': 'একটি লক্ষণ লিখুন...',
    },
    'selected_symptoms': {
      'en': 'Selected Symptoms',
      'bn': 'নির্বাচিত লক্ষণ',
    },
    'common_symptoms': {
      'en': 'Common Symptoms',
      'bn': 'সাধারণ লক্ষণ',
    },
    'analyze': {
      'en': 'Analyze Symptoms',
      'bn': 'লক্ষণ বিশ্লেষণ করুন',
    },
    'analyzing_symptoms': {
      'en': 'Analyzing Your Symptoms',
      'bn': 'আপনার লক্ষণ বিশ্লেষণ করা হচ্ছে',
    },
    'please_wait': {
      'en': 'Please wait while our AI processes your symptoms',
      'bn': 'আমাদের AI আপনার লক্ষণগুলি প্রক্রিয়া করার সময় অপেক্ষা করুন',
    },
    'no_results': {
      'en': 'No results found',
      'bn': 'কোনো ফলাফল পাওয়া যায়নি',
    },
    'summary': {
      'en': 'Summary',
      'bn': 'সারাংশ',
    },
    'possible_conditions': {
      'en': 'Possible Conditions',
      'bn': 'সম্ভাব্য অবস্থা',
    },
    'recommendations': {
      'en': 'Recommendations',
      'bn': 'সুপারিশ',
    },
    'when_to_seek_help': {
      'en': 'When to Seek Medical Help',
      'bn': 'কখন চিকিৎসা সাহায্য নিতে হবে',
    },
    'start_over': {
      'en': 'Start Over',
      'bn': 'আবার শুরু করুন',
    },
    
    // Find Doctor
    'find_nearby_doctors': {
      'en': 'Find Nearby Doctors',
      'bn': 'কাছাকাছি ডাক্তার খুঁজুন',
    },
    'search_by_name_specialty': {
      'en': 'Search by name or specialty',
      'bn': 'নাম বা বিশেষত্ব দ্বারা অনুসন্ধান করুন',
    },
    'all_specialties': {
      'en': 'All Specialties',
      'bn': 'সকল বিশেষত্ব',
    },
    'cardiologist': {
      'en': 'Cardiologist',
      'bn': 'হৃদরোগ বিশেষজ্ঞ',
    },
    'dermatologist': {
      'en': 'Dermatologist',
      'bn': 'চর্মরোগ বিশেষজ্ঞ',
    },
    'neurologist': {
      'en': 'Neurologist',
      'bn': 'স্নায়ুরোগ বিশেষজ্ঞ',
    },
    'pediatrician': {
      'en': 'Pediatrician',
      'bn': 'শিশু বিশেষজ্ঞ',
    },
    'orthopedic': {
      'en': 'Orthopedic',
      'bn': 'হাড় বিশেষজ্ঞ',
    },
    'general_physician': {
      'en': 'General Physician',
      'bn': 'সাধারণ চিকিৎসক',
    },
    'gynecologist': {
      'en': 'Gynecologist',
      'bn': 'স্ত্রীরোগ বিশেষজ্ঞ',
    },
    'ent_specialist': {
      'en': 'ENT Specialist',
      'bn': 'নাক কান গলা বিশেষজ্ঞ',
    },
    'rating': {
      'en': 'Rating',
      'bn': 'রেটিং',
    },
    'experience': {
      'en': 'Experience',
      'bn': 'অভিজ্ঞতা',
    },
    'book_now': {
      'en': 'Book Now',
      'bn': 'এখনই বুক করুন',
    },
    'view_profile': {
      'en': 'View Profile',
      'bn': 'প্রোফাইল দেখুন',
    },
    'filter': {
      'en': 'Filter',
      'bn': 'ফিল্টার',
    },
    'sort_by': {
      'en': 'Sort By',
      'bn': 'সাজান',
    },
    'nearest': {
      'en': 'Nearest',
      'bn': 'নিকটতম',
    },
    'top_rated': {
      'en': 'Top Rated',
      'bn': 'সর্বোচ্চ রেটিং',
    },
    'lowest_fee': {
      'en': 'Lowest Fee',
      'bn': 'সর্বনিম্ন ফি',
    },
    'most_experienced': {
      'en': 'Most Experienced',
      'bn': 'সর্বাধিক অভিজ্ঞ',
    },
    'list_view': {
      'en': 'List View',
      'bn': 'তালিকা দৃশ্য',
    },
    'map_view': {
      'en': 'Map View',
      'bn': 'মানচিত্র দৃশ্য',
    },
    'no_doctors_found': {
      'en': 'No doctors found',
      'bn': 'কোনো ডাক্তার পাওয়া যায়নি',
    },
    'try_different_filters': {
      'en': 'Try different search filters',
      'bn': 'বিভিন্ন অনুসন্ধান ফিল্টার চেষ্টা করুন',
    },
  };
}
