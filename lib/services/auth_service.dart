import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Sign up with email and password
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': role,
        },
      );

      if (response.user != null) {
        return {
          'success': true,
          'message': 'Account created successfully!',
          'user': response.user,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create account',
        };
      }
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign in with email and password
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return {
          'success': true,
          'message': 'Signed in successfully!',
          'user': response.user,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to sign in',
        };
      }
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign out
  static Future<Map<String, dynamic>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return {
        'success': true,
        'message': 'Signed out successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to sign out',
      };
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Check if user is signed in
  static bool isSignedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Get current session
  static Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  // Reset password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
  }) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return {
        'success': true,
        'message': 'Password reset email sent!',
      };
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? role,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (role != null) updates['role'] = role;

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: updates),
      );

      if (response.user != null) {
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'user': response.user,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
}
