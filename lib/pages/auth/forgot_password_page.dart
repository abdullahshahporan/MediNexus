import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

/// Forgot Password Page with glassmorphism design
class ForgotPasswordPage extends StatefulWidget {
  final String role;

  const ForgotPasswordPage({super.key, required this.role});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _emailSent = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool get isDoctor => widget.role == 'doctor';

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
    super.dispose();
  }

  void _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.resetPassword(_emailController.text.trim());

      if (!mounted) return;

      if (success) {
        setState(() => _emailSent = true);
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
                child: _emailSent
                    ? _buildSuccessContent(langProvider, primaryColor, textColor, textSecondary)
                    : _buildFormContent(isDark, langProvider, primaryColor, textColor, textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(bool isDark, LanguageProvider langProvider,
      Color primaryColor, Color textColor, Color textSecondary) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          _buildHeader(isDark, textColor),
          const SizedBox(height: 40),
          
          // Icon and Title
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  langProvider.translate('forgot_password_title'),
                  style: AppTextStyles.displaySmall(textColor),
                ),
                const SizedBox(height: 12),
                Text(
                  langProvider.translate('forgot_password_subtitle'),
                  style: AppTextStyles.bodyMedium(textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // Email field
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
          const SizedBox(height: 32),
          
          // Send button
          GlassButton(
            text: _isLoading
                ? langProvider.translate('sending')
                : langProvider.translate('send_reset_link'),
            onPressed: _isLoading ? null : _sendResetEmail,
            isLoading: _isLoading,
            gradient: LinearGradient(
              colors: isDoctor
                  ? [AppColors.doctorAccent, AppColors.secondary]
                  : [AppColors.patientAccent, AppColors.primary],
            ),
          ),
          const SizedBox(height: 24),
          
          // Back to sign in link
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                langProvider.translate('back_to_sign_in'),
                style: AppTextStyles.labelLarge(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(LanguageProvider langProvider,
      Color primaryColor, Color textColor, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 60,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 32),
        
        Text(
          langProvider.translate('check_your_email'),
          style: AppTextStyles.displaySmall(textColor),
        ),
        const SizedBox(height: 16),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            langProvider.translate('reset_email_sent_message'),
            style: AppTextStyles.bodyMedium(textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        
        Text(
          _emailController.text,
          style: AppTextStyles.titleMedium(primaryColor),
        ),
        const SizedBox(height: 48),
        
        // Back to sign in button
        GlassButton(
          text: langProvider.translate('back_to_sign_in'),
          onPressed: () => Navigator.of(context).pop(),
          isOutlined: true,
        ),
        const SizedBox(height: 16),
        
        // Resend link
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            langProvider.translate('didnt_receive_email'),
            style: AppTextStyles.bodyMedium(textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Row(
      children: [
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
      ],
    );
  }
}
