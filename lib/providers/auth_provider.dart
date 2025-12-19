import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// AuthProvider - Manages authentication state and user data
class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _user;
  UserProfile? _profile;
  DoctorProfile? _doctorProfile;
  PatientProfile? _patientProfile;
  
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  User? get user => _user;
  UserProfile? get profile => _profile;
  DoctorProfile? get doctorProfile => _doctorProfile;
  PatientProfile? get patientProfile => _patientProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;
  bool get isDoctor => _profile?.role == UserRole.doctor;
  bool get isPatient => _profile?.role == UserRole.patient;
  String get userId => _user?.id ?? '';

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _user = _supabase.auth.currentUser;
    
    if (_user != null) {
      await _loadProfile();
    }
    
    _isInitialized = true;
    notifyListeners();
    
    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        _user = session.user;
        _loadProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _clearData();
      }
    });
  }

  Future<void> _loadProfile() async {
    if (_user == null) return;
    
    try {
      // Load base profile
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', _user!.id)
          .single();
      
      _profile = UserProfile.fromJson(profileData);
      
      // Load role-specific profile
      if (_profile!.role == UserRole.doctor) {
        final doctorData = await _supabase
            .from('doctor_profiles')
            .select('*, profiles(*)')
            .eq('user_id', _user!.id)
            .single();
        _doctorProfile = DoctorProfile.fromJson(doctorData);
      } else if (_profile!.role == UserRole.patient) {
        final patientData = await _supabase
            .from('patient_profiles')
            .select('*, profiles(*)')
            .eq('user_id', _user!.id)
            .single();
        _patientProfile = PatientProfile.fromJson(patientData);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  void _clearData() {
    _user = null;
    _profile = null;
    _doctorProfile = null;
    _patientProfile = null;
    _error = null;
    notifyListeners();
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        await _loadProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phone,
    DateTime? dateOfBirth,
    Gender? gender,
    BloodGroup? bloodGroup,
    String? address,
    String? city,
    // Doctor-specific fields
    String? specialization,
    String? bmdcRegistration,
    List<String>? qualifications,
    int? experienceYears,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Sign up with Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        
        // Create base profile
        await _supabase.from('profiles').insert({
          'id': _user!.id,
          'email': email,
          'full_name': fullName,
          'role': role.name,
          'phone': phone,
          'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
          'gender': gender?.name,
          'blood_group': bloodGroup?.display,
          'address': address,
          'city': city,
        });

        // Create role-specific profile
        if (role == UserRole.doctor) {
          await _supabase.from('doctor_profiles').insert({
            'user_id': _user!.id,
            'specialization': specialization ?? 'General',
            'bmdc_registration': bmdcRegistration,
            'qualifications': qualifications ?? [],
            'experience_years': experienceYears ?? 0,
          });
        } else if (role == UserRole.patient) {
          await _supabase.from('patient_profiles').insert({
            'user_id': _user!.id,
          });
        }

        await _loadProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Sign up failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.signOut();
      _clearData();
    } catch (e) {
      _error = 'Sign out failed. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabase.auth.resetPasswordForEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update profile
  Future<bool> updateProfile({
    String? fullName,
    String? displayName,
    String? phone,
    String? avatarUrl,
    DateTime? dateOfBirth,
    Gender? gender,
    BloodGroup? bloodGroup,
    String? address,
    String? city,
    String? emergencyContact,
    String? emergencyPhone,
    String? languagePreference,
    String? themePreference,
    bool? notificationEnabled,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (displayName != null) updates['display_name'] = displayName;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (dateOfBirth != null) {
        updates['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      }
      if (gender != null) updates['gender'] = gender.name;
      if (bloodGroup != null) updates['blood_group'] = bloodGroup.display;
      if (address != null) updates['address'] = address;
      if (city != null) updates['city'] = city;
      if (emergencyContact != null) updates['emergency_contact'] = emergencyContact;
      if (emergencyPhone != null) updates['emergency_phone'] = emergencyPhone;
      if (languagePreference != null) updates['language_preference'] = languagePreference;
      if (themePreference != null) updates['theme_preference'] = themePreference;
      if (notificationEnabled != null) updates['notification_enabled'] = notificationEnabled;

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', _user!.id);

      await _loadProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update doctor profile
  Future<bool> updateDoctorProfile({
    String? specialization,
    String? subSpecialization,
    String? bio,
    double? consultationFee,
    double? followUpFee,
    double? videoConsultationFee,
    int? averageConsultationDuration,
    bool? isOnline,
    bool? isAcceptingAppointments,
  }) async {
    if (_user == null || !isDoctor) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      
      if (specialization != null) updates['specialization'] = specialization;
      if (subSpecialization != null) updates['sub_specialization'] = subSpecialization;
      if (bio != null) updates['bio'] = bio;
      if (consultationFee != null) updates['consultation_fee'] = consultationFee;
      if (followUpFee != null) updates['follow_up_fee'] = followUpFee;
      if (videoConsultationFee != null) updates['video_consultation_fee'] = videoConsultationFee;
      if (averageConsultationDuration != null) {
        updates['average_consultation_duration'] = averageConsultationDuration;
      }
      if (isOnline != null) {
        updates['is_online'] = isOnline;
        updates['last_online_at'] = isOnline ? DateTime.now().toIso8601String() : null;
      }
      if (isAcceptingAppointments != null) {
        updates['is_accepting_appointments'] = isAcceptingAppointments;
      }

      await _supabase
          .from('doctor_profiles')
          .update(updates)
          .eq('user_id', _user!.id);

      await _loadProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update doctor profile. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update patient profile
  Future<bool> updatePatientProfile({
    String? medicalHistory,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<String>? currentMedications,
    double? heightCm,
    double? weightKg,
    String? insuranceProvider,
    String? insurancePolicyNumber,
    String? primaryDoctorId,
  }) async {
    if (_user == null || !isPatient) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      
      if (medicalHistory != null) updates['medical_history'] = medicalHistory;
      if (allergies != null) updates['allergies'] = allergies;
      if (chronicConditions != null) updates['chronic_conditions'] = chronicConditions;
      if (currentMedications != null) updates['current_medications'] = currentMedications;
      if (heightCm != null) updates['height_cm'] = heightCm;
      if (weightKg != null) updates['weight_kg'] = weightKg;
      if (insuranceProvider != null) updates['insurance_provider'] = insuranceProvider;
      if (insurancePolicyNumber != null) updates['insurance_policy_number'] = insurancePolicyNumber;
      if (primaryDoctorId != null) updates['primary_doctor_id'] = primaryDoctorId;

      await _supabase
          .from('patient_profiles')
          .update(updates)
          .eq('user_id', _user!.id);

      await _loadProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update patient profile. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle doctor online status
  Future<bool> toggleOnlineStatus() async {
    if (!isDoctor || _doctorProfile == null) return false;
    
    return await updateDoctorProfile(isOnline: !_doctorProfile!.isOnline);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
