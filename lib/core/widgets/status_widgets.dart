import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Status Pill - Shows online/offline status or appointment status
class StatusPill extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool showDot;
  final double fontSize;

  const StatusPill({
    super.key,
    required this.label,
    this.type = StatusType.neutral,
    this.showDot = true,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getBorderColor(), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getDotColor(),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case StatusType.online:
        return AppColors.successBg;
      case StatusType.offline:
        return AppColors.offline.withOpacity(0.15);
      case StatusType.busy:
        return AppColors.errorBg;
      case StatusType.away:
        return AppColors.warningBg;
      case StatusType.waiting:
        return AppColors.warningBg;
      case StatusType.confirmed:
        return AppColors.successBg;
      case StatusType.completed:
        return AppColors.infoBg;
      case StatusType.cancelled:
        return AppColors.errorBg;
      case StatusType.neutral:
        return AppColors.offline.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case StatusType.online:
        return AppColors.success.withOpacity(0.3);
      case StatusType.offline:
        return AppColors.offline.withOpacity(0.3);
      case StatusType.busy:
        return AppColors.error.withOpacity(0.3);
      case StatusType.away:
        return AppColors.warning.withOpacity(0.3);
      case StatusType.waiting:
        return AppColors.warning.withOpacity(0.3);
      case StatusType.confirmed:
        return AppColors.success.withOpacity(0.3);
      case StatusType.completed:
        return AppColors.info.withOpacity(0.3);
      case StatusType.cancelled:
        return AppColors.error.withOpacity(0.3);
      case StatusType.neutral:
        return AppColors.offline.withOpacity(0.2);
    }
  }

  Color _getDotColor() {
    switch (type) {
      case StatusType.online:
        return AppColors.success;
      case StatusType.offline:
        return AppColors.offline;
      case StatusType.busy:
        return AppColors.error;
      case StatusType.away:
        return AppColors.warning;
      case StatusType.waiting:
        return AppColors.warning;
      case StatusType.confirmed:
        return AppColors.success;
      case StatusType.completed:
        return AppColors.info;
      case StatusType.cancelled:
        return AppColors.error;
      case StatusType.neutral:
        return AppColors.offline;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StatusType.online:
        return AppColors.success;
      case StatusType.offline:
        return AppColors.offline;
      case StatusType.busy:
        return AppColors.error;
      case StatusType.away:
        return AppColors.warning;
      case StatusType.waiting:
        return AppColors.warning;
      case StatusType.confirmed:
        return AppColors.success;
      case StatusType.completed:
        return AppColors.info;
      case StatusType.cancelled:
        return AppColors.error;
      case StatusType.neutral:
        return AppColors.offline;
    }
  }
}

enum StatusType {
  online,
  offline,
  busy,
  away,
  waiting,
  confirmed,
  completed,
  cancelled,
  neutral,
}

/// Adherence Heatmap - 7-day adherence tracker
class AdherenceHeatmap extends StatelessWidget {
  final List<AdherenceRow> rows;
  final List<String> days;

  const AdherenceHeatmap({
    super.key,
    required this.rows,
    this.days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Day headers
        Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) {
              return SizedBox(
                width: 32,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Rows
        ...rows.map((row) => _HeatmapRow(row: row, isDark: isDark)),
      ],
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  final AdherenceRow row;
  final bool isDark;

  const _HeatmapRow({required this.row, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                Icon(
                  row.icon,
                  size: 16,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    row.label,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: row.values.map((value) {
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _getColor(value),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(AdherenceValue value) {
    switch (value) {
      case AdherenceValue.complete:
        return AppColors.adherenceComplete;
      case AdherenceValue.partial:
        return AppColors.adherencePartial;
      case AdherenceValue.missed:
        return AppColors.adherenceMissed;
      case AdherenceValue.none:
        return AppColors.adherenceNone;
    }
  }
}

class AdherenceRow {
  final String label;
  final IconData icon;
  final List<AdherenceValue> values;

  const AdherenceRow({
    required this.label,
    required this.icon,
    required this.values,
  });
}

enum AdherenceValue {
  complete,
  partial,
  missed,
  none,
}
