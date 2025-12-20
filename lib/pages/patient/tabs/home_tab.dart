import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/appointment_card.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/status_widgets.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/language_provider.dart';

class HomeTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;
  final LanguageProvider lang;

  const HomeTab({
    super.key,
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
                      child: QuickActionCard(
                        icon: Icons.medical_services_rounded,
                        label: 'Find Doctor',
                        color: AppColors.doctorAccent,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
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
                      child: QuickActionCard(
                        icon: Icons.medication_rounded,
                        label: 'Medicine Routine',
                        color: AppColors.success,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
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

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
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
