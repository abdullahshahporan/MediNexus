import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import 'intro_page.dart';

class HomePage extends StatelessWidget {
  final String role;
  
  const HomePage({super.key, required this.role});

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A1A),
                  Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header
                    _buildGlassContainer(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getRoleIcon(role),
                              size: 32,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  langProvider.translate('welcome'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showLogoutDialog(context, langProvider),
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Role Badge
                    _buildGlassContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${langProvider.translate('logged_in_as')} ${langProvider.translate(role)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Success Message
                    Expanded(
                      child: Center(
                        child: _buildGlassContainer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 80,
                                color: Colors.green.withOpacity(0.8),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                langProvider.translate('auth_success'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                langProvider.translate('logged_into'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'User ID: ${user?.id ?? 'N/A'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.4),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
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

  void _showLogoutDialog(BuildContext context, LanguageProvider langProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        title: Text(
          langProvider.translate('sign_out'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
          ),
        ),
        content: Text(
          langProvider.translate('sign_out_confirm'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              langProvider.translate('cancel'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntroPage(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              foregroundColor: Colors.red.withOpacity(0.9),
            ),
            child: Text(langProvider.translate('sign_out')),
          ),
        ],
      ),
    );
  }
}
