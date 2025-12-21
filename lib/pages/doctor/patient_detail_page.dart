import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

/// Patient Detail View - Deep dive into patient data
class PatientDetailPage extends StatefulWidget {
  final String patientName;
  final int patientAge;
  final String patientId;

  const PatientDetailPage({
    super.key,
    required this.patientName,
    required this.patientAge,
    required this.patientId,
  });

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.patientName,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${widget.patientId} • ${widget.patientAge} years',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Latest Vitals Summary
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _VitalChip(label: 'BP', value: '120/80', unit: 'mmHg'),
                        Container(
                          width: 1,
                          height: 30,
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        _VitalChip(label: 'Weight', value: '75', unit: 'kg'),
                        Container(
                          width: 1,
                          height: 30,
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        _VitalChip(label: 'Temp', value: '98.6', unit: '°F'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.doctorAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'Overview & Adherence'),
                        Tab(text: 'History & Docs'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(isDark: isDark),
                  _HistoryTab(isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showPrescriptionDialog(context);
        },
        backgroundColor: AppColors.doctorAccent,
        icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
        label: const Text(
          'Start Consultation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showPrescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Consultation'),
        content: const Text('Would you like to start a new consultation and write a prescription?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to prescription writing screen
            },
            child: Text('Start', style: TextStyle(color: AppColors.doctorAccent)),
          ),
        ],
      ),
    );
  }
}

class _VitalChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _VitalChip({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Overview & Adherence Tab
class _OverviewTab extends StatelessWidget {
  final bool isDark;

  const _OverviewTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Adherence Heatmap
        Text(
          'Adherence Heatmap (Last 7 Days)',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _AdherenceRow(
                label: 'Medication',
                days: [true, true, false, true, true, true, true],
              ),
              const SizedBox(height: 12),
              _AdherenceRow(
                label: 'Workout',
                days: [true, false, false, true, false, true, true],
              ),
              const SizedBox(height: 12),
              _AdherenceRow(
                label: 'Diet',
                days: [true, true, true, false, true, true, false],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend('Completed', AppColors.success),
                  const SizedBox(width: 16),
                  _buildLegend('Missed', AppColors.error),
                  const SizedBox(width: 16),
                  _buildLegend('No Schedule', Colors.grey),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Current Symptoms
        Text(
          'Current Symptoms',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _SymptomCard(
          symptom: 'Mild Headache',
          date: 'Today',
          severity: 'Mild',
        ),
        const SizedBox(height: 8),
        _SymptomCard(
          symptom: 'Nausea',
          date: 'Yesterday',
          severity: 'Moderate',
        ),
        
        const SizedBox(height: 24),
        
        // Health Metrics
        Text(
          'Recent Health Metrics',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _MetricRow(label: 'Blood Pressure', value: '120/80 mmHg', status: 'Normal'),
              const Divider(height: 24),
              _MetricRow(label: 'Blood Sugar', value: '110 mg/dL', status: 'Normal'),
              const Divider(height: 24),
              _MetricRow(label: 'Heart Rate', value: '72 bpm', status: 'Normal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _AdherenceRow extends StatelessWidget {
  final String label;
  final List<bool> days;

  const _AdherenceRow({
    required this.label,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  if (label == 'Medication')
                    Text(
                      dayLabels[index],
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        fontSize: 10,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: days[index] ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: days[index]
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : const Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SymptomCard extends StatelessWidget {
  final String symptom;
  final String date;
  final String severity;

  const _SymptomCard({
    required this.symptom,
    required this.date,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final severityColor = severity == 'Mild'
        ? AppColors.warning
        : severity == 'Moderate'
            ? Colors.orange
            : AppColors.error;

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.medical_information_rounded, color: severityColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symptom,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              severity,
              style: TextStyle(
                color: severityColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String status;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// History & Docs Tab
class _HistoryTab extends StatelessWidget {
  final bool isDark;

  const _HistoryTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Medical History',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _HistoryCard(
          title: 'Prescription - Hypertension',
          date: 'Dec 15, 2025',
          type: 'Prescription',
        ),
        const SizedBox(height: 8),
        _HistoryCard(
          title: 'Lab Report - Blood Test',
          date: 'Dec 10, 2025',
          type: 'Lab Report',
        ),
        const SizedBox(height: 8),
        _HistoryCard(
          title: 'Consultation Notes',
          date: 'Dec 5, 2025',
          type: 'Note',
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String type;

  const _HistoryCard({
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconData = type == 'Prescription'
        ? Icons.receipt_long_rounded
        : type == 'Lab Report'
            ? Icons.science_rounded
            : Icons.note_rounded;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.doctorAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: AppColors.doctorAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
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
