import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import 'doctor/doctor_dashboard_page.dart';
import 'intro_page.dart';
import 'patient/patient_dashboard_page.dart';

class HomePage extends StatefulWidget {
  final String role;
  
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Navigate to appropriate dashboard after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _navigateToDashboard();
      }
    });
  }

  void _navigateToDashboard() {
    final authProvider = context.read<AuthProvider>();
    final userRole = authProvider.profile?.role;

    Widget dashboard;
    if (userRole == UserRole.doctor || widget.role.toLowerCase() == 'doctor') {
      dashboard = const DoctorDashboardPage();
    } else {
      dashboard = const PatientDashboardPage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => dashboard,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final user = AuthService.getCurrentUser();
        final userName = user?.userMetadata?['name'] ?? 'User';

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.role.toLowerCase() == 'doctor'
                    ? [
                        const Color(0xFF0A0E27),
                        const Color(0xFF1A1F3A),
                        const Color(0xFF0A0E27),
                      ]
                    : [
                        const Color(0xFF0A1F1A),
                        const Color(0xFF1A3A2A),
                        const Color(0xFF0A1F1A),
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon with glow
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.5 + (value * 0.5),
                            child: Opacity(
                              opacity: value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: widget.role.toLowerCase() == 'doctor'
                                        ? [
                                            const Color(0xFF3B82F6),
                                            const Color(0xFF2563EB),
                                          ]
                                        : [
                                            const Color(0xFF10B981),
                                            const Color(0xFF059669),
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.role.toLowerCase() == 'doctor'
                                              ? const Color(0xFF3B82F6)
                                              : const Color(0xFF10B981))
                                          .withOpacity(0.5 * value),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getRoleIcon(widget.role),
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // Welcome Text with fade animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Column(
                              children: [
                                Text(
                                  langProvider.translate('welcome'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.7),
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_user_rounded,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        langProvider.translate(widget.role),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(0.9),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.role.toLowerCase() == 'doctor'
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading your dashboard...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return Icons.medical_information_outlined;
      case 'patient':
      default:
        return Icons.person_outline_rounded;
    }
  }
}
