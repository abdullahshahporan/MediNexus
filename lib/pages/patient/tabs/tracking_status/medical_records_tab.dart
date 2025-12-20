import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class MedicalRecordsTab extends StatefulWidget {
  final bool isDark;

  const MedicalRecordsTab({super.key, required this.isDark});

  @override
  State<MedicalRecordsTab> createState() => _MedicalRecordsTabState();
}

class _MedicalRecordsTabState extends State<MedicalRecordsTab> {
  bool showBPChart = true;
  bool showWeightChart = true;

  final List<FlSpot> bpData = [
    const FlSpot(0, 115),
    const FlSpot(1, 118),
    const FlSpot(2, 122),
    const FlSpot(3, 120),
    const FlSpot(4, 125),
    const FlSpot(5, 119),
    const FlSpot(6, 120),
  ];

  final List<FlSpot> weightData = [
    const FlSpot(0, 72),
    const FlSpot(1, 71.5),
    const FlSpot(2, 71),
    const FlSpot(3, 70.5),
    const FlSpot(4, 70),
    const FlSpot(5, 70.2),
    const FlSpot(6, 70),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isDark
              ? [AppColors.darkBg1, AppColors.darkBg2]
              : [AppColors.lightBg1, AppColors.lightBg2],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Medical Records',
                style: TextStyle(
                  color: widget.isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Vitals Trends Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vitals Trends',
                    style: TextStyle(
                      color: widget.isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Blood Pressure Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Blood Pressure',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Latest reading: 120/80 mmHg',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                showBPChart
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                color: widget.isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                              onPressed: () {
                                setState(() => showBPChart = !showBPChart);
                              },
                            ),
                          ],
                        ),
                        if (showBPChart) ...[
                          const SizedBox(height: 20),
                          Text(
                            'BP (last 30 days)',
                            style: TextStyle(
                              color: widget.isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 150,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 10,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: widget.isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.black.withOpacity(0.05),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                minX: 0,
                                maxX: 6,
                                minY: 110,
                                maxY: 130,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: bpData,
                                    isCurved: true,
                                    color: AppColors.patientAccent,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 4,
                                              color: AppColors.patientAccent,
                                              strokeWidth: 2,
                                              strokeColor: widget.isDark
                                                  ? AppColors.darkBg
                                                  : AppColors.lightBg,
                                            );
                                          },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.patientAccent
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weight/BMI Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight/BMI',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Latest reading: 70 kg | BMI 22.5',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                showWeightChart
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                color: widget.isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                              onPressed: () {
                                setState(
                                  () => showWeightChart = !showWeightChart,
                                );
                              },
                            ),
                          ],
                        ),
                        if (showWeightChart) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Weight (last 30 days)',
                            style: TextStyle(
                              color: widget.isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 150,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: widget.isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.black.withOpacity(0.05),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                minX: 0,
                                maxX: 6,
                                minY: 69,
                                maxY: 73,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: weightData,
                                    isCurved: true,
                                    color: Colors.green,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 4,
                                              color: Colors.green,
                                              strokeWidth: 2,
                                              strokeColor: widget.isDark
                                                  ? AppColors.darkBg
                                                  : AppColors.lightBg,
                                            );
                                          },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.green.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Recent Documents Section
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
                        'Recent Documents',
                        style: TextStyle(
                          color: widget.isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.patientAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    icon: Icons.description_rounded,
                    iconBg: Colors.blue,
                    title: 'Blood Test Report',
                    date: 'Oct 20, 2025',
                    type: 'PDF',
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    icon: Icons.medical_information_rounded,
                    iconBg: Colors.green,
                    title: 'Prescription - Dr. Rahman',
                    date: 'Oct 14, 2025',
                    type: 'Rx',
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    icon: Icons.description_rounded,
                    iconBg: Colors.orange,
                    title: 'Prescription Report',
                    date: 'Oct 18, 2025',
                    type: 'PDF',
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    icon: Icons.description_rounded,
                    iconBg: Colors.teal,
                    title: 'Prescription - Report',
                    date: 'Oct 15, 2025',
                    type: 'PDF',
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    icon: Icons.description_rounded,
                    iconBg: Colors.blue,
                    title: 'Blood Test Report',
                    date: 'Oct 20, 2025',
                    type: 'PDF',
                    isDark: widget.isDark,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String date;
  final String type;
  final bool isDark;

  const _DocumentCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.date,
    required this.type,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: iconBg, size: 32),
                if (type == 'PDF')
                  Positioned(
                    bottom: 8,
                    child: Text(
                      type,
                      style: TextStyle(
                        color: iconBg,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.visibility_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
