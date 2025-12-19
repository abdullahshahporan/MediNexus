import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/grok_ai_service.dart';

/// AI-powered Symptom Checker Page
/// Uses Grok AI to analyze symptoms and provide health guidance
class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final GrokAIService _grokService = GrokAIService();
  final _customSymptomController = TextEditingController();
  
  final List<String> _selectedSymptoms = [];
  bool _isAnalyzing = false;
  SymptomAnalysisResult? _analysisResult;
  String? _errorMessage;

  // Common symptoms list
  final List<_SymptomItem> _commonSymptoms = [
    _SymptomItem('Headache', Icons.psychology_rounded),
    _SymptomItem('Fever', Icons.thermostat_rounded),
    _SymptomItem('Cough', Icons.air_rounded),
    _SymptomItem('Sore throat', Icons.sick_rounded),
    _SymptomItem('Body aches', Icons.accessibility_new_rounded),
    _SymptomItem('Fatigue', Icons.battery_1_bar_rounded),
    _SymptomItem('Nausea', Icons.face_retouching_off_rounded),
    _SymptomItem('Dizziness', Icons.rotate_left_rounded),
    _SymptomItem('Chest pain', Icons.favorite_rounded),
    _SymptomItem('Shortness of breath', Icons.air_rounded),
    _SymptomItem('Runny nose', Icons.face_rounded),
    _SymptomItem('Stomach pain', Icons.circle_rounded),
  ];

  @override
  void dispose() {
    _customSymptomController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
      _analysisResult = null;
      _errorMessage = null;
    });
  }

  void _addCustomSymptom() {
    final symptom = _customSymptomController.text.trim();
    if (symptom.isNotEmpty && !_selectedSymptoms.contains(symptom)) {
      setState(() {
        _selectedSymptoms.add(symptom);
        _customSymptomController.clear();
      });
    }
  }

  Future<void> _analyzeSymptoms() async {
    if (_selectedSymptoms.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final result = await _grokService.analyzeSymptoms(
        symptoms: _selectedSymptoms,
      );
      
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to analyze symptoms. Please try again.';
        _isAnalyzing = false;
      });
    }
  }

  void _resetAnalysis() {
    setState(() {
      _selectedSymptoms.clear();
      _analysisResult = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg1, AppColors.darkBg2, AppColors.darkBg1]
                : [AppColors.lightBg1, AppColors.lightBg2, AppColors.lightBg3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(isDark, textColor, textSecondary, langProvider),
              
              // Content
              Expanded(
                child: _analysisResult != null
                    ? _buildResultView(isDark, textColor, textSecondary, langProvider)
                    : _buildSymptomSelector(isDark, textColor, textSecondary, langProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor, Color textSecondary, LanguageProvider langProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_rounded, color: textColor),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkGlassWhite
                  : AppColors.lightGlassWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langProvider.translate('symptom_checker'),
                  style: AppTextStyles.titleLarge(textColor),
                ),
                Text(
                  langProvider.translate('ai_powered_health_analysis'),
                  style: AppTextStyles.bodySmall(textSecondary),
                ),
              ],
            ),
          ),
          // AI Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.patientAccent, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'AI',
                  style: AppTextStyles.labelSmall(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSelector(bool isDark, Color textColor, Color textSecondary, LanguageProvider langProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructions
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.patientAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.patientAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    langProvider.translate('select_symptoms_instruction'),
                    style: AppTextStyles.bodyMedium(textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Selected symptoms
          if (_selectedSymptoms.isNotEmpty) ...[
            Text(
              '${langProvider.translate('selected_symptoms')} (${_selectedSymptoms.length})',
              style: AppTextStyles.titleMedium(textColor),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedSymptoms.map((symptom) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.patientAccent, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        symptom,
                        style: AppTextStyles.labelMedium(Colors.white),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _toggleSymptom(symptom),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Common symptoms
          Text(
            langProvider.translate('common_symptoms'),
            style: AppTextStyles.titleMedium(textColor),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonSymptoms.map((item) {
              final isSelected = _selectedSymptoms.contains(item.name);
              return GestureDetector(
                onTap: () => _toggleSymptom(item.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.patientAccent
                        : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.patientAccent
                          : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: isSelected ? Colors.white : textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.name,
                        style: AppTextStyles.labelMedium(
                          isSelected ? Colors.white : textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Custom symptom input
          Text(
            langProvider.translate('add_custom_symptom'),
            style: AppTextStyles.titleMedium(textColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkGlassWhite
                            : AppColors.lightGlassWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                        ),
                      ),
                      child: TextField(
                        controller: _customSymptomController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: langProvider.translate('type_symptom'),
                          hintStyle: TextStyle(color: textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onSubmitted: (_) => _addCustomSymptom(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.patientAccent, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: _addCustomSymptom,
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTextStyles.bodyMedium(AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

          // Analyze button
          GlassButton(
            text: _isAnalyzing 
                ? langProvider.translate('analyzing')
                : langProvider.translate('analyze_symptoms'),
            onPressed: _selectedSymptoms.isEmpty || _isAnalyzing ? null : _analyzeSymptoms,
            gradient: const LinearGradient(
              colors: [AppColors.patientAccent, AppColors.primary],
            ),
            icon: _isAnalyzing ? null : Icons.auto_awesome,
            isLoading: _isAnalyzing,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildResultView(bool isDark, Color textColor, Color textSecondary, LanguageProvider langProvider) {
    final result = _analysisResult!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Urgency indicator
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(result.urgency).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getUrgencyIcon(result.urgency),
                    size: 40,
                    color: _getUrgencyColor(result.urgency),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getUrgencyText(result.urgency),
                  style: AppTextStyles.titleLarge(_getUrgencyColor(result.urgency)),
                ),
                const SizedBox(height: 8),
                Text(
                  langProvider.translate('urgency_level'),
                  style: AppTextStyles.bodySmall(textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Possible conditions
          if (result.possibleConditions.isNotEmpty) ...[
            Text(
              langProvider.translate('possible_conditions'),
              style: AppTextStyles.titleMedium(textColor),
            ),
            const SizedBox(height: 12),
            ...result.possibleConditions.map((condition) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.patientAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.medical_information_rounded,
                          color: AppColors.patientAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          condition,
                          style: AppTextStyles.bodyMedium(textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],

          // Recommendation
          Text(
            langProvider.translate('recommendation'),
            style: AppTextStyles.titleMedium(textColor),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              result.recommendation,
              style: AppTextStyles.bodyMedium(textColor),
            ),
          ),
          const SizedBox(height: 24),

          // Immediate actions (if any)
          if (result.immediateActions.isNotEmpty) ...[
            Text(
              langProvider.translate('immediate_actions'),
              style: AppTextStyles.titleMedium(textColor),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: result.immediateActions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            action,
                            style: AppTextStyles.bodyMedium(textColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Warning (if any)
          if (result.warning != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_rounded, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.warning!,
                      style: AppTextStyles.bodyMedium(AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    langProvider.translate('ai_disclaimer'),
                    style: AppTextStyles.bodySmall(textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  text: langProvider.translate('start_over'),
                  onPressed: _resetAnalysis,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassButton(
                  text: langProvider.translate('find_doctor'),
                  onPressed: () {
                    // TODO: Navigate to find doctor
                  },
                  gradient: const LinearGradient(
                    colors: [AppColors.patientAccent, AppColors.primary],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.error;
      case 'emergency':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  IconData _getUrgencyIcon(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return Icons.check_circle_outline_rounded;
      case 'medium':
        return Icons.info_outline_rounded;
      case 'high':
        return Icons.warning_amber_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getUrgencyText(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return 'Low Urgency';
      case 'medium':
        return 'Medium Urgency';
      case 'high':
        return 'High Urgency';
      case 'emergency':
        return 'EMERGENCY';
      default:
        return urgency;
    }
  }
}

/// Symptom item for display
class _SymptomItem {
  final String name;
  final IconData icon;

  _SymptomItem(this.name, this.icon);
}
