import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_card.dart';
import 'status_widgets.dart';

/// Appointment Card - Shows appointment details with patient/doctor info
class AppointmentCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? imageUrl;
  final String time;
  final String? duration;
  final StatusType status;
  final String statusLabel;
  final bool isDoctor;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onVideo;
  final VoidCallback? onChat;

  const AppointmentCard({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
    required this.time,
    this.duration,
    this.status = StatusType.waiting,
    this.statusLabel = 'Waiting',
    this.isDoctor = false,
    this.onTap,
    this.onCall,
    this.onVideo,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              _Avatar(imageUrl: imageUrl, name: name, isDoctor: isDoctor),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusPill(label: statusLabel, type: status, fontSize: 11),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Time & Actions
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (duration != null) ...[
                Text(
                  ' • $duration',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
              const Spacer(),
              // Action buttons
              if (onCall != null)
                _ActionButton(
                  icon: Icons.phone_rounded,
                  onTap: onCall!,
                  color: AppColors.success,
                ),
              if (onVideo != null) ...[
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.videocam_rounded,
                  onTap: onVideo!,
                  color: AppColors.doctorAccent,
                ),
              ],
              if (onChat != null) ...[
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.chat_bubble_rounded,
                  onTap: onChat!,
                  color: AppColors.info,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final bool isDoctor;

  const _Avatar({this.imageUrl, required this.name, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDoctor ? AppColors.doctorAccent : AppColors.patientAccent;
    
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor.withOpacity(0.2),
        border: Border.all(color: bgColor.withOpacity(0.3), width: 2),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: bgColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

/// Quick Appointment Slot - For selecting time slots
class AppointmentSlot extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const AppointmentSlot({
    super.key,
    required this.time,
    this.isSelected = false,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color bgColor;
    Color textColor;
    Color borderColor;
    
    if (!isAvailable) {
      bgColor = (isDark ? AppColors.darkCardBg : AppColors.lightCardBg).withOpacity(0.5);
      textColor = isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled;
      borderColor = Colors.transparent;
    } else if (isSelected) {
      bgColor = AppColors.doctorAccent;
      textColor = Colors.white;
      borderColor = AppColors.doctorAccent;
    } else {
      bgColor = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
      borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
    
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Day Selector - For selecting days in schedule
class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;
  final List<DateTime>? dates;

  const DaySelector({
    super.key,
    this.days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    required this.selectedIndex,
    required this.onDaySelected,
    this.dates,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final date = dates != null && index < dates!.length ? dates![index].day.toString() : null;
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == days.length - 1 ? 0 : 0,
            ),
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.doctorAccent
                      : (isDark ? AppColors.darkCardBg : AppColors.lightCardBg),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.doctorAccent
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
