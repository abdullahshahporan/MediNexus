import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/appointments_tab.dart';
import 'tabs/tracking_status/medicine_tracking_tab.dart';
import 'tabs/tracking_status/combined_records_tab.dart';
import 'tabs/profile_tab.dart';

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
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            HomeTab(
              isDark: isDark,
              auth: auth,
              lang: lang,
              onProfileTap: () => setState(() => _selectedNavIndex = 4),
            ),
            AppointmentsTab(isDark: isDark),
            MedicineTrackingTab(isDark: isDark),
            CombinedRecordsTab(isDark: isDark),
            ProfileTab(isDark: isDark, auth: auth),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 80,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.7)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.patientAccent.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ]
                    : [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.1),
                      ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: _selectedNavIndex == 0,
                  onTap: () => setState(() => _selectedNavIndex = 0),
                  color: AppColors.patientAccent,
                  isDark: isDark,
                ),
                _NavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Appointment',
                  isSelected: _selectedNavIndex == 1,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                  color: AppColors.patientAccent,
                  isDark: isDark,
                ),
                _NavItem(
                  icon: Icons.medication_outlined,
                  label: 'Medicine',
                  isSelected: _selectedNavIndex == 2,
                  onTap: () => setState(() => _selectedNavIndex = 2),
                  color: AppColors.patientAccent,
                  isDark: isDark,
                ),
                _NavItem(
                  icon: Icons.folder_rounded,
                  label: 'Records',
                  isSelected: _selectedNavIndex == 3,
                  onTap: () => setState(() => _selectedNavIndex = 3),
                  color: AppColors.patientAccent,
                  isDark: isDark,
                ),
              ],
            ),
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
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? color
                    : (isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.4)),
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? color
                      : (isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.4)),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
