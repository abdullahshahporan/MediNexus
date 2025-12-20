import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/appointment_card.dart';
import '../../../core/widgets/status_widgets.dart';

class AppointmentsTab extends StatelessWidget {
  final bool isDark;

  const AppointmentsTab({
    super.key,
    required this.isDark,
  });

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
