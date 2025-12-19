import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/appointment_card.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_widgets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

/// Patient Dashboard - Main home screen for patients
class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            _HomeTab(isDark: isDark, auth: auth, lang: lang),
            _AppointmentsTab(isDark: isDark),
            _HealthTab(isDark: isDark),
            _ProfileTab(isDark: isDark, auth: auth),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardBg.withOpacity(0.95)
            : AppColors.lightCardBg.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _selectedNavIndex == 0,
                onTap: () => setState(() => _selectedNavIndex = 0),
                color: AppColors.patientAccent,
              ),
              _NavItem(
                icon: Icons.calendar_month_rounded,
                label: 'Appointments',
                isSelected: _selectedNavIndex == 1,
                onTap: () => setState(() => _selectedNavIndex = 1),
                color: AppColors.patientAccent,
              ),
              _NavItem(
                icon: Icons.favorite_rounded,
                label: 'Health',
                isSelected: _selectedNavIndex == 2,
                onTap: () => setState(() => _selectedNavIndex = 2),
                color: AppColors.patientAccent,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: _selectedNavIndex == 3,
                onTap: () => setState(() => _selectedNavIndex = 3),
                color: AppColors.patientAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? color
                    : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Home Tab
class _HomeTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;
  final LanguageProvider lang;

  const _HomeTab({
    required this.isDark,
    required this.auth,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    final greeting = _getGreeting();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile?.displayName ?? profile?.fullName ?? 'Patient',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.patientGradient,
                        border: Border.all(
                          color: AppColors.patientAccent.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          profile?.initials ?? 'P',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Quick Actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.medical_services_rounded,
                        label: 'Find Doctor',
                        color: AppColors.doctorAccent,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.health_and_safety_rounded,
                        label: 'Symptom Check',
                        color: AppColors.patientAccent,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.medication_rounded,
                        label: 'Medicine Routine',
                        color: AppColors.success,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.description_rounded,
                        label: 'Prescriptions',
                        color: AppColors.warning,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Today's Schedule
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.patientAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sample Appointment Card
                AppointmentCard(
                  name: 'Dr. Aminul Islam',
                  subtitle: 'Cardiologist',
                  time: '10:30 AM',
                  duration: '30 min',
                  status: StatusType.confirmed,
                  statusLabel: 'Confirmed',
                  isDoctor: true,
                  onTap: () {},
                  onVideo: () {},
                  onChat: () {},
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Medicine Adherence
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Adherence',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: AdherenceHeatmap(
                    rows: [
                      AdherenceRow(
                        label: 'Morning',
                        icon: Icons.wb_sunny_rounded,
                        values: [
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.partial,
                          AdherenceValue.complete,
                          AdherenceValue.missed,
                          AdherenceValue.complete,
                          AdherenceValue.none,
                        ],
                      ),
                      AdherenceRow(
                        label: 'Afternoon',
                        icon: Icons.wb_cloudy_rounded,
                        values: [
                          AdherenceValue.complete,
                          AdherenceValue.missed,
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.partial,
                          AdherenceValue.none,
                        ],
                      ),
                      AdherenceRow(
                        label: 'Night',
                        icon: Icons.nightlight_rounded,
                        values: [
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.missed,
                          AdherenceValue.complete,
                          AdherenceValue.complete,
                          AdherenceValue.none,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Appointments Tab
class _AppointmentsTab extends StatelessWidget {
  final bool isDark;

  const _AppointmentsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Appointments',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Upcoming appointments list
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AppointmentCard(
                  name: 'Dr. Aminul Islam',
                  subtitle: 'Cardiologist',
                  time: '10:30 AM • Dec 20, 2024',
                  status: StatusType.confirmed,
                  statusLabel: 'Confirmed',
                  isDoctor: true,
                  onTap: () {},
                  onCall: () {},
                  onVideo: () {},
                  onChat: () {},
                ),
                const SizedBox(height: 12),
                AppointmentCard(
                  name: 'Dr. Fatima Rahman',
                  subtitle: 'Dermatologist',
                  time: '3:00 PM • Dec 22, 2024',
                  status: StatusType.waiting,
                  statusLabel: 'Pending',
                  isDoctor: true,
                  onTap: () {},
                  onChat: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Health Tab
class _HealthTab extends StatelessWidget {
  final bool isDark;

  const _HealthTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'My Health',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Health cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _HealthStatCard(
                  icon: Icons.favorite_rounded,
                  label: 'Heart Rate',
                  value: '72',
                  unit: 'BPM',
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                _HealthStatCard(
                  icon: Icons.water_drop_rounded,
                  label: 'Blood Pressure',
                  value: '120/80',
                  unit: 'mmHg',
                  color: AppColors.info,
                ),
                const SizedBox(height: 12),
                _HealthStatCard(
                  icon: Icons.monitor_weight_rounded,
                  label: 'Weight',
                  value: '68',
                  unit: 'kg',
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _HealthStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

/// Profile Tab
class _ProfileTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;

  const _ProfileTab({
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
                _ProfileOption(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.dark_mode_outlined,
                  label: 'Theme',
                  onTap: () {},
                ),
                _ProfileOption(
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/intro', (route) => false);
            },
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileOption({
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
