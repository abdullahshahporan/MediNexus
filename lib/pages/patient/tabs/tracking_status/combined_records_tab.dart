import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import 'workout_tracking_tab.dart';
import 'medical_records_tab.dart';

class CombinedRecordsTab extends StatelessWidget {
  final bool isDark;

  const CombinedRecordsTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Header with tabs
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.darkBg1, AppColors.darkBg2]
                    : [AppColors.lightBg1, AppColors.lightBg2],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Records',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GlassCard(
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.patientAccent, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Workout'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_information_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Medical'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                WorkoutTrackingTab(isDark: isDark),
                MedicalRecordsTab(isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
