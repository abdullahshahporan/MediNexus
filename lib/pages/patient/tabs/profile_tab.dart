import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../providers/auth_provider.dart';
import '../../intro_page.dart';

class ProfileTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;

  const ProfileTab({
    super.key,
    required this.isDark,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.patientGradient,
                    border: Border.all(
                      color: AppColors.patientAccent.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile?.initials ?? 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile?.fullName ?? 'Patient',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? '',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Settings options
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ProfileOption(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.dark_mode_outlined,
                  label: 'Theme',
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                GlassButton(
                  text: 'Sign Out',
                  icon: Icons.logout_rounded,
                  onPressed: () => _showSignOutDialog(context),
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await auth.signOut();
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
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
        ],
      ),
    );
  }
}
