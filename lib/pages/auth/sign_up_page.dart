import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_text_field.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../doctor/doctor_dashboard_page.dart';
import '../patient/patient_dashboard_page.dart';
import 'sign_in_page.dart';

/// Enhanced Sign Up Page with multi-step registration
class EnhancedSignUpPage extends StatefulWidget {
  final String role;

  const EnhancedSignUpPage({super.key, required this.role});

  @override
  State<EnhancedSignUpPage> createState() => _EnhancedSignUpPageState();
}

class _EnhancedSignUpPageState extends State<EnhancedSignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Doctor specific controllers
  final _qualificationController = TextEditingController();
  final _specializationController = TextEditingController();
  final _bmdcController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  int _currentStep = 0;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool get isDoctor => widget.role == 'doctor';
  int get totalSteps => isDoctor ? 3 : 2;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    _specializationController.dispose();
    _bmdcController.dispose();
    _consultationFeeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showError('Please agree to the terms and conditions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      
      await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        role: isDoctor ? UserRole.doctor : UserRole.patient,
        phone: _phoneController.text.trim(),
        specialization: isDoctor ? _specializationController.text.trim() : null,
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
                      const SizedBox(height: 24),
                      
                      // Logo and Title
                      _buildTitle(langProvider, primaryColor, textColor, textSecondary),
                      const SizedBox(height: 24),
                      
                      // Step indicator
                      _buildStepIndicator(primaryColor, textColor, textSecondary),
                      const SizedBox(height: 32),
                      
                      // Form content based on current step
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildCurrentStepContent(
                          isDark, langProvider, primaryColor, textColor, textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Navigation buttons
                      _buildNavigationButtons(langProvider, primaryColor),
                      const SizedBox(height: 24),
                      
                      // Sign in link
                      _buildSignInLink(langProvider, primaryColor, textSecondary),
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
          onPressed: _previousStep,
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

  Widget _buildTitle(LanguageProvider langProvider, Color primaryColor,
      Color textColor, Color textSecondary) {
    return Center(
      child: Column(
        children: [
          // Logo
          Container(
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
          ),
          const SizedBox(height: 16),
          Text(
            langProvider.translate('create_account'),
            style: AppTextStyles.displaySmall(textColor),
          ),
          const SizedBox(height: 8),
          Text(
            isDoctor
                ? langProvider.translate('sign_up_doctor_subtitle')
                : langProvider.translate('sign_up_patient_subtitle'),
            style: AppTextStyles.bodyMedium(textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(Color primaryColor, Color textColor, Color textSecondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;
        
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? primaryColor
                    : (isActive ? primaryColor.withOpacity(0.2) : Colors.transparent),
                border: Border.all(
                  color: isActive || isCompleted ? primaryColor : textSecondary.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : Text(
                        '${index + 1}',
                        style: AppTextStyles.labelMedium(
                          isActive ? primaryColor : textSecondary,
                        ),
                      ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 40,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isCompleted ? primaryColor : textSecondary.withOpacity(0.3),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentStepContent(bool isDark, LanguageProvider langProvider,
      Color primaryColor, Color textColor, Color textSecondary) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(langProvider, textSecondary);
      case 1:
        return _buildSecurityStep(langProvider, textSecondary);
      case 2:
        return isDoctor 
            ? _buildProfessionalInfoStep(langProvider, textSecondary)
            : _buildTermsStep(langProvider, primaryColor, textColor, textSecondary);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoStep(LanguageProvider langProvider, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey('basic_info'),
      children: [
        Text(
          langProvider.translate('basic_information'),
          style: AppTextStyles.headlineMedium(textSecondary),
        ),
        const SizedBox(height: 20),
        
        // Full name
        GlassTextField(
          controller: _nameController,
          label: langProvider.translate('full_name'),
          hint: langProvider.translate('full_name_hint'),
          prefixIcon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('name_required');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Email
        GlassTextField(
          controller: _emailController,
          label: langProvider.translate('email'),
          hint: langProvider.translate('email_hint'),
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
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
        
        // Phone
        GlassTextField(
          controller: _phoneController,
          label: langProvider.translate('phone'),
          hint: langProvider.translate('phone_hint'),
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('phone_required');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSecurityStep(LanguageProvider langProvider, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey('security'),
      children: [
        Text(
          langProvider.translate('security'),
          style: AppTextStyles.headlineMedium(textSecondary),
        ),
        const SizedBox(height: 20),
        
        // Password
        GlassTextField(
          controller: _passwordController,
          label: langProvider.translate('password'),
          hint: langProvider.translate('password_hint'),
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
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
            if (value.length < 8) {
              return langProvider.translate('password_min_length');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Confirm Password
        GlassTextField(
          controller: _confirmPasswordController,
          label: langProvider.translate('confirm_password'),
          hint: langProvider.translate('confirm_password_hint'),
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: textSecondary,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('confirm_password_required');
            }
            if (value != _passwordController.text) {
              return langProvider.translate('passwords_not_match');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Password strength indicator
        _buildPasswordStrength(langProvider),
      ],
    );
  }

  Widget _buildPasswordStrength(LanguageProvider langProvider) {
    final password = _passwordController.text;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    Color strengthColor;
    String strengthText;
    
    switch (strength) {
      case 0:
      case 1:
        strengthColor = AppColors.error;
        strengthText = langProvider.translate('weak');
        break;
      case 2:
        strengthColor = AppColors.warning;
        strengthText = langProvider.translate('fair');
        break;
      case 3:
        strengthColor = AppColors.info;
        strengthText = langProvider.translate('good');
        break;
      default:
        strengthColor = AppColors.success;
        strengthText = langProvider.translate('strong');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: strength / 4,
                  backgroundColor: strengthColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(strengthColor),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strengthText,
              style: AppTextStyles.labelSmall(strengthColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoStep(LanguageProvider langProvider, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey('professional'),
      children: [
        Text(
          langProvider.translate('professional_information'),
          style: AppTextStyles.headlineMedium(textSecondary),
        ),
        const SizedBox(height: 20),
        
        // Specialization
        GlassTextField(
          controller: _specializationController,
          label: langProvider.translate('specialization'),
          hint: langProvider.translate('specialization_hint'),
          prefixIcon: Icons.medical_services_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return langProvider.translate('specialization_required');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Qualification
        GlassTextField(
          controller: _qualificationController,
          label: langProvider.translate('qualification'),
          hint: langProvider.translate('qualification_hint'),
          prefixIcon: Icons.school_outlined,
        ),
        const SizedBox(height: 16),
        
        // BMDC Number
        GlassTextField(
          controller: _bmdcController,
          label: langProvider.translate('bmdc_number'),
          hint: langProvider.translate('bmdc_hint'),
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        
        // Consultation Fee
        GlassTextField(
          controller: _consultationFeeController,
          label: langProvider.translate('consultation_fee'),
          hint: langProvider.translate('consultation_fee_hint'),
          prefixIcon: Icons.attach_money_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        
        // Terms checkbox
        _buildTermsCheckbox(langProvider, textSecondary),
      ],
    );
  }

  Widget _buildTermsStep(LanguageProvider langProvider, Color primaryColor,
      Color textColor, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey('terms'),
      children: [
        Text(
          langProvider.translate('almost_done'),
          style: AppTextStyles.headlineMedium(textSecondary),
        ),
        const SizedBox(height: 20),
        
        _buildTermsCheckbox(langProvider, textSecondary),
      ],
    );
  }

  Widget _buildTermsCheckbox(LanguageProvider langProvider, Color textSecondary) {
    final primaryColor = isDoctor ? AppColors.doctorAccent : AppColors.patientAccent;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
            activeColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            children: [
              Text(
                langProvider.translate('agree_to'),
                style: AppTextStyles.bodySmall(textSecondary),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Show terms
                },
                child: Text(
                  langProvider.translate('terms_of_service'),
                  style: AppTextStyles.bodySmall(primaryColor),
                ),
              ),
              Text(
                langProvider.translate('and'),
                style: AppTextStyles.bodySmall(textSecondary),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Show privacy policy
                },
                child: Text(
                  langProvider.translate('privacy_policy'),
                  style: AppTextStyles.bodySmall(primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(LanguageProvider langProvider, Color primaryColor) {
    final isLastStep = _currentStep == totalSteps - 1;
    
    return Column(
      children: [
        // Main action button
        GlassButton(
          text: isLastStep
              ? (_isLoading ? langProvider.translate('creating_account') : langProvider.translate('create_account'))
              : langProvider.translate('continue'),
          onPressed: _isLoading ? null : (isLastStep ? _signUp : _nextStep),
          isLoading: _isLoading,
          gradient: LinearGradient(
            colors: isDoctor
                ? [AppColors.doctorAccent, AppColors.secondary]
                : [AppColors.patientAccent, AppColors.primary],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInLink(LanguageProvider langProvider, Color primaryColor, Color textSecondary) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            langProvider.translate('have_account'),
            style: AppTextStyles.bodyMedium(textSecondary),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignInPage(isDoctor: isDoctor),
              ),
            ),
            child: Text(
              langProvider.translate('sign_in'),
              style: AppTextStyles.labelLarge(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
