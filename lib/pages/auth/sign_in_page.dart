import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../doctor/doctor_dashboard_page.dart';
import '../patient/patient_dashboard_page.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart' show EnhancedSignUpPage;

/// Enhanced Sign In Page with glassmorphism design
class SignInPage extends StatefulWidget {
  final bool isDoctor;

  const SignInPage({
    super.key,
    required this.isDoctor,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get isDoctor => widget.isDoctor;

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => isDoctor
                ? const DoctorDashboardPage()
                : const PatientDashboardPage(),
          ),
          (route) => false,
        );
      } else if (authProvider.error != null) {
        _showError(authProvider.error!);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    final primaryColor = isDoctor ? AppColors.doctorAccent : AppColors.patientAccent;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg1, AppColors.darkBg2, AppColors.darkBg1]
                : [AppColors.lightBg1, AppColors.lightBg2, AppColors.lightBg3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button and toggles
                      _buildHeader(isDark, langProvider, themeProvider, textColor),
                      const SizedBox(height: 32),
                      
                      // Logo and Title
                      Center(
                        child: Column(
                          children: [
                            _buildLogo(primaryColor),
                            const SizedBox(height: 16),
                            Text(
                              langProvider.translate('welcome_back'),
                              style: AppTextStyles.displaySmall(textColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isDoctor
                                  ? langProvider.translate('sign_in_doctor_subtitle')
                                  : langProvider.translate('sign_in_patient_subtitle'),
                              style: AppTextStyles.bodyMedium(textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Role indicator
                      _buildRoleIndicator(isDark, langProvider, primaryColor),
                      const SizedBox(height: 24),
                      
                      // Sign in form
                      _buildForm(isDark, langProvider, primaryColor, textSecondary),
                      const SizedBox(height: 24),
                      
                      // Sign up link
                      _buildSignUpLink(langProvider, primaryColor, textSecondary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, LanguageProvider langProvider, 
      ThemeProvider themeProvider, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: textColor,
          ),
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.darkGlassWhite
                : AppColors.lightGlassWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // Theme and language toggles
        Row(
          children: [
            // Theme toggle
            IconButton(
              onPressed: themeProvider.toggleTheme,
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: textColor,
              ),
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.darkGlassWhite
                    : AppColors.lightGlassWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Language toggle
            IconButton(
              onPressed: langProvider.toggleLanguage,
              icon: Text(
                langProvider.isBangla ? 'EN' : 'বাং',
                style: AppTextStyles.labelMedium(textColor),
              ),
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.darkGlassWhite
                    : AppColors.lightGlassWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo(Color primaryColor) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDoctor
              ? [AppColors.doctorAccent, AppColors.secondary]
              : [AppColors.patientAccent, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        isDoctor ? Icons.medical_services_rounded : Icons.favorite_rounded,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRoleIndicator(bool isDark, LanguageProvider langProvider, Color primaryColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDoctor ? Icons.medical_services_outlined : Icons.person_outline_rounded,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isDoctor
                    ? langProvider.translate('signing_in_as_doctor')
                    : langProvider.translate('signing_in_as_patient'),
                style: AppTextStyles.labelLarge(primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isDark, LanguageProvider langProvider,
      Color primaryColor, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        GlassTextField(
          controller: _emailController,
          label: langProvider.translate('email'),
          hint: langProvider.translate('email_hint'),
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('email_required');
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return langProvider.translate('email_invalid');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Password field
        GlassTextField(
          controller: _passwordController,
          label: langProvider.translate('password'),
          hint: langProvider.translate('password_hint'),
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onEditingComplete: _signIn,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: textSecondary,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('password_required');
            }
            if (value.length < 6) {
              return langProvider.translate('password_min_length');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Remember me and forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remember me
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    activeColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  langProvider.translate('remember_me'),
                  style: AppTextStyles.bodySmall(textSecondary),
                ),
              ],
            ),
            // Forgot password
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(role: isDoctor ? 'doctor' : 'patient'),
                ),
              ),
              child: Text(
                langProvider.translate('forgot_password'),
                style: AppTextStyles.bodySmall(primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Sign in button
        GlassButton(
          text: _isLoading
              ? langProvider.translate('signing_in')
              : langProvider.translate('sign_in'),
          onPressed: _isLoading ? null : _signIn,
          isLoading: _isLoading,
          gradient: LinearGradient(
            colors: isDoctor
                ? [AppColors.doctorAccent, AppColors.secondary]
                : [AppColors.patientAccent, AppColors.primary],
          ),
        ),
        const SizedBox(height: 24),
        
        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                langProvider.translate('or'),
                style: AppTextStyles.bodySmall(textSecondary),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Social sign in buttons
        _buildSocialButtons(langProvider),
      ],
    );
  }

  Widget _buildSocialButtons(LanguageProvider langProvider) {
    return Column(
      children: [
        // Google sign in
        GlassButton(
          text: langProvider.translate('continue_with_google'),
          onPressed: () {
            // TODO: Implement Google sign in
            _showError('Google sign in coming soon');
          },
          icon: Icons.g_mobiledata_rounded,
          isOutlined: true,
        ),
        const SizedBox(height: 12),
        
        // Apple sign in (iOS only in real app)
        GlassButton(
          text: langProvider.translate('continue_with_apple'),
          onPressed: () {
            // TODO: Implement Apple sign in
            _showError('Apple sign in coming soon');
          },
          icon: Icons.apple_rounded,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildSignUpLink(LanguageProvider langProvider, Color primaryColor, Color textSecondary) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            langProvider.translate('no_account'),
            style: AppTextStyles.bodyMedium(textSecondary),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => EnhancedSignUpPage(role: isDoctor ? 'doctor' : 'patient'),
              ),
            ),
            child: Text(
              langProvider.translate('sign_up'),
              style: AppTextStyles.labelLarge(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
