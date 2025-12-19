import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

/// Find Doctor Page - Search and filter doctors
/// Uses OpenStreetMap for location-based search
class FindDoctorPage extends StatefulWidget {
  const FindDoctorPage({super.key});

  @override
  State<FindDoctorPage> createState() => _FindDoctorPageState();
}

class _FindDoctorPageState extends State<FindDoctorPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSpecialization = 'All';
  String _sortBy = 'rating';
  bool _showFilters = false;

  // Specializations
  final List<String> _specializations = [
    'All',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'General Physician',
    'Neurologist',
    'Orthopedic',
    'ENT Specialist',
    'Gynecologist',
    'Psychiatrist',
  ];

  // Mock doctors data (using DoctorProfile model structure)
  final List<_MockDoctor> _doctors = [
    _MockDoctor(
      id: '1',
      name: 'Dr. Sarah Ahmed',
      specialization: 'Cardiologist',
      qualifications: ['MBBS', 'MD (Cardiology)'],
      experienceYears: 15,
      consultationFee: 1500,
      rating: 4.9,
      totalReviews: 234,
      isOnline: true,
      bmdcRegistration: 'A-12345',
    ),
    _MockDoctor(
      id: '2',
      name: 'Dr. Karim Rahman',
      specialization: 'Dermatologist',
      qualifications: ['MBBS', 'DDV'],
      experienceYears: 10,
      consultationFee: 1200,
      rating: 4.7,
      totalReviews: 189,
      isOnline: false,
      bmdcRegistration: 'A-23456',
    ),
    _MockDoctor(
      id: '3',
      name: 'Dr. Fatima Khan',
      specialization: 'Pediatrician',
      qualifications: ['MBBS', 'DCH'],
      experienceYears: 8,
      consultationFee: 1000,
      rating: 4.8,
      totalReviews: 312,
      isOnline: true,
      bmdcRegistration: 'A-34567',
    ),
    _MockDoctor(
      id: '4',
      name: 'Dr. Abdullah Hassan',
      specialization: 'General Physician',
      qualifications: ['MBBS'],
      experienceYears: 5,
      consultationFee: 800,
      rating: 4.5,
      totalReviews: 156,
      isOnline: true,
      bmdcRegistration: 'A-45678',
    ),
    _MockDoctor(
      id: '5',
      name: 'Dr. Nusrat Jahan',
      specialization: 'Neurologist',
      qualifications: ['MBBS', 'MD (Neurology)'],
      experienceYears: 12,
      consultationFee: 1800,
      rating: 4.9,
      totalReviews: 201,
      isOnline: false,
      bmdcRegistration: 'A-56789',
    ),
  ];

  List<_MockDoctor> get _filteredDoctors {
    var result = _doctors.where((d) {
      final matchesSearch = _searchQuery.isEmpty ||
          d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.specialization.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesSpecialization = _selectedSpecialization == 'All' ||
          d.specialization == _selectedSpecialization;
      
      return matchesSearch && matchesSpecialization;
    }).toList();

    // Sort
    switch (_sortBy) {
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'fee_low':
        result.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
        break;
      case 'experience':
        result.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
    }

    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              
              // Search & Filters
              _buildSearchAndFilters(isDark, textColor, textSecondary, langProvider),
              
              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredDoctors.length} ${langProvider.translate('doctors_found')}',
                      style: AppTextStyles.bodyMedium(textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => _showSortOptions(context, isDark, textColor, langProvider),
                      child: Row(
                        children: [
                          Icon(Icons.sort_rounded, size: 18, color: AppColors.patientAccent),
                          const SizedBox(width: 4),
                          Text(
                            langProvider.translate('sort_by'),
                            style: AppTextStyles.labelMedium(AppColors.patientAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Doctors list
              Expanded(
                child: _filteredDoctors.isEmpty
                    ? _buildEmptyState(langProvider, textSecondary)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
                          return _DoctorCard(
                            doctor: doctor,
                            isDark: isDark,
                            textColor: textColor,
                            textSecondary: textSecondary,
                            langProvider: langProvider,
                            onTap: () {
                              // TODO: Navigate to doctor profile
                            },
                            onBook: () {
                              // TODO: Book appointment
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor, Color textSecondary, LanguageProvider langProvider) {
    return Padding(
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
                  langProvider.translate('find_doctor'),
                  style: AppTextStyles.titleLarge(textColor),
                ),
                Text(
                  langProvider.translate('search_specialists'),
                  style: AppTextStyles.bodySmall(textSecondary),
                ),
              ],
            ),
          ),
          // Map toggle
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.patientAccent, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Toggle map view
              },
              icon: const Icon(Icons.map_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isDark, Color textColor, Color textSecondary, LanguageProvider langProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search bar
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
                        controller: _searchController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: langProvider.translate('search_doctors'),
                          hintStyle: TextStyle(color: textSecondary),
                          prefixIcon: Icon(Icons.search_rounded, color: textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => setState(() => _showFilters = !_showFilters),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _showFilters
                        ? AppColors.patientAccent
                        : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _showFilters
                          ? AppColors.patientAccent
                          : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _showFilters ? Colors.white : textSecondary,
                  ),
                ),
              ),
            ],
          ),
          
          // Filters
          if (_showFilters) ...[
            const SizedBox(height: 16),
            _buildSpecializationFilter(isDark, textColor, textSecondary),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecializationFilter(bool isDark, Color textColor, Color textSecondary) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _specializations.length,
        itemBuilder: (context, index) {
          final spec = _specializations[index];
          final isSelected = _selectedSpecialization == spec;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedSpecialization = spec),
            child: Container(
              margin: EdgeInsets.only(right: index < _specializations.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.patientAccent
                    : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.patientAccent
                      : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                spec,
                style: AppTextStyles.labelMedium(isSelected ? Colors.white : textColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider langProvider, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            langProvider.translate('no_doctors_found'),
            style: AppTextStyles.titleMedium(textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            langProvider.translate('try_different_search'),
            style: AppTextStyles.bodySmall(textSecondary),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context, bool isDark, Color textColor, LanguageProvider langProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg2 : AppColors.lightBg1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              langProvider.translate('sort_by'),
              style: AppTextStyles.titleLarge(textColor),
            ),
            const SizedBox(height: 20),
            _buildSortOption(
              langProvider.translate('highest_rating'),
              'rating',
              Icons.star_rounded,
              isDark,
              textColor,
            ),
            _buildSortOption(
              langProvider.translate('lowest_fee'),
              'fee_low',
              Icons.attach_money_rounded,
              isDark,
              textColor,
            ),
            _buildSortOption(
              langProvider.translate('most_experienced'),
              'experience',
              Icons.workspace_premium_rounded,
              isDark,
              textColor,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String value, IconData icon, bool isDark, Color textColor) {
    final isSelected = _sortBy == value;
    
    return GestureDetector(
      onTap: () {
        setState(() => _sortBy = value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.patientAccent.withOpacity(0.1)
              : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.patientAccent
                : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.patientAccent : textColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.bodyMedium(isSelected ? AppColors.patientAccent : textColor),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.patientAccent),
          ],
        ),
      ),
    );
  }
}

/// Doctor card widget
class _DoctorCard extends StatelessWidget {
  final _MockDoctor doctor;
  final bool isDark;
  final Color textColor;
  final Color textSecondary;
  final LanguageProvider langProvider;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const _DoctorCard({
    required this.doctor,
    required this.isDark,
    required this.textColor,
    required this.textSecondary,
    required this.langProvider,
    required this.onTap,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.patientAccent, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      if (doctor.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.online,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkBg1 : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctor.name,
                                style: AppTextStyles.titleMedium(textColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    doctor.rating.toStringAsFixed(1),
                                    style: AppTextStyles.labelSmall(AppColors.warning),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialization,
                          style: AppTextStyles.bodySmall(AppColors.patientAccent),
                        ),
                        Text(
                          doctor.qualifications.join(', '),
                          style: AppTextStyles.labelSmall(textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Stats row
              Row(
                children: [
                  _buildStat(
                    Icons.workspace_premium_rounded,
                    '${doctor.experienceYears} ${langProvider.translate('years')}',
                    textSecondary,
                  ),
                  _buildStat(
                    Icons.rate_review_rounded,
                    '${doctor.totalReviews} ${langProvider.translate('reviews')}',
                    textSecondary,
                  ),
                  _buildStat(
                    Icons.payments_rounded,
                    '৳${doctor.consultationFee.toInt()}',
                    AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GlassButton(
                      text: langProvider.translate('view_profile'),
                      onPressed: onTap,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      text: langProvider.translate('book_now'),
                      onPressed: onBook,
                      gradient: const LinearGradient(
                        colors: [AppColors.patientAccent, AppColors.primary],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.labelSmall(color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock doctor class for display
class _MockDoctor {
  final String id;
  final String name;
  final String specialization;
  final List<String> qualifications;
  final int experienceYears;
  final double consultationFee;
  final double rating;
  final int totalReviews;
  final bool isOnline;
  final String bmdcRegistration;

  _MockDoctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualifications,
    required this.experienceYears,
    required this.consultationFee,
    required this.rating,
    required this.totalReviews,
    required this.isOnline,
    required this.bmdcRegistration,
  });
}
