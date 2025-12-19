import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/appointment_card.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/status_widgets.dart';
import '../../providers/auth_provider.dart';

/// Doctor Dashboard - Main home screen for doctors
class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            _DashboardTab(isDark: isDark, auth: auth),
            _ScheduleTab(isDark: isDark),
            _PatientsTab(isDark: isDark),
            _ProfileTab(isDark: isDark, auth: auth),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardBg.withOpacity(0.95)
            : AppColors.lightCardBg.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isSelected: _selectedNavIndex == 0,
                onTap: () => setState(() => _selectedNavIndex = 0),
                color: AppColors.doctorAccent,
              ),
              _NavItem(
                icon: Icons.calendar_month_rounded,
                label: 'Schedule',
                isSelected: _selectedNavIndex == 1,
                onTap: () => setState(() => _selectedNavIndex = 1),
                color: AppColors.doctorAccent,
              ),
              _NavItem(
                icon: Icons.people_rounded,
                label: 'Patients',
                isSelected: _selectedNavIndex == 2,
                onTap: () => setState(() => _selectedNavIndex = 2),
                color: AppColors.doctorAccent,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: _selectedNavIndex == 3,
                onTap: () => setState(() => _selectedNavIndex = 3),
                color: AppColors.doctorAccent,
              ),
            ],
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

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? color
                    : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard Tab
class _DashboardTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;

  const _DashboardTab({
    required this.isDark,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    final doctorProfile = auth.doctorProfile;

    return CustomScrollView(
      slivers: [
        // Header with Online Toggle
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.doctorGradient,
                        border: Border.all(
                          color: AppColors.doctorAccent.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          profile?.initials ?? 'D',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${profile?.fullName ?? 'Doctor'}',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctorProfile?.specialization ?? 'Specialist',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Online Status Toggle
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: doctorProfile?.isOnline == true
                              ? AppColors.success
                              : AppColors.offline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorProfile?.isOnline == true
                                  ? 'You are Online'
                                  : 'You are Offline',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              doctorProfile?.isOnline == true
                                  ? 'Accepting online consultations'
                                  : 'Not accepting online consultations',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: doctorProfile?.isOnline ?? false,
                        onChanged: (value) => auth.toggleOnlineStatus(),
                        activeColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Stats Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Overview',
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
                      child: _StatCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'Appointments',
                        value: '12',
                        color: AppColors.doctorAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        label: 'Completed',
                        value: '5',
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pending_rounded,
                        label: 'Pending',
                        value: '7',
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_rounded,
                        label: 'Total Patients',
                        value: '${doctorProfile?.totalPatients ?? 0}',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Upcoming Appointments
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
                      'Upcoming Appointments',
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
                          color: AppColors.doctorAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sample Patient Cards
                AppointmentCard(
                  name: 'Ahmed Hassan',
                  subtitle: 'Chest pain, shortness of breath',
                  time: '10:30 AM',
                  duration: '15 min',
                  status: StatusType.waiting,
                  statusLabel: 'In Queue',
                  isDoctor: false,
                  onTap: () {},
                  onCall: () {},
                  onChat: () {},
                ),
                const SizedBox(height: 12),
                AppointmentCard(
                  name: 'Fatima Begum',
                  subtitle: 'Follow-up consultation',
                  time: '11:00 AM',
                  duration: '15 min',
                  status: StatusType.confirmed,
                  statusLabel: 'Confirmed',
                  isDoctor: false,
                  onTap: () {},
                  onChat: () {},
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

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
                      child: _QuickActionBtn(
                        icon: Icons.edit_note_rounded,
                        label: 'New Prescription',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionBtn(
                        icon: Icons.schedule_rounded,
                        label: 'Manage Schedule',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: label,
      icon: icon,
      onPressed: onTap,
      isOutlined: true,
    );
  }
}

/// Schedule Tab
class _ScheduleTab extends StatefulWidget {
  final bool isDark;

  const _ScheduleTab({required this.isDark});

  @override
  State<_ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<_ScheduleTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = 0;

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
    final isDark = widget.isDark;
    
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Tabs
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
                    Tab(text: 'In-Person'),
                    Tab(text: 'Online'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Day Selector
              DaySelector(
                selectedIndex: _selectedDayIndex,
                onDaySelected: (index) {
                  setState(() => _selectedDayIndex = index);
                },
                dates: List.generate(7, (index) {
                  return DateTime.now().add(Duration(days: index));
                }),
              ),
            ],
          ),
        ),
        // Schedule Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _InPersonSchedule(isDark: isDark),
              _OnlineSchedule(isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }
}

class _InPersonSchedule extends StatelessWidget {
  final bool isDark;

  const _InPersonSchedule({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Chamber Selection
        GlassCard(
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
                child: Icon(Icons.location_on_rounded, color: AppColors.doctorAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City Medical Center',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Dhanmondi, Dhaka',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Time Slots
        Text(
          'Available Slots',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppointmentSlot(time: '09:00 AM', isAvailable: true),
            AppointmentSlot(time: '09:30 AM', isAvailable: false),
            AppointmentSlot(time: '10:00 AM', isAvailable: true),
            AppointmentSlot(time: '10:30 AM', isSelected: true),
            AppointmentSlot(time: '11:00 AM', isAvailable: true),
            AppointmentSlot(time: '11:30 AM', isAvailable: true),
            AppointmentSlot(time: '12:00 PM', isAvailable: false),
            AppointmentSlot(time: '12:30 PM', isAvailable: true),
          ],
        ),
        const SizedBox(height: 20),
        // Appointments for selected time
        Text(
          'Appointments',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        AppointmentCard(
          name: 'Ahmed Hassan',
          subtitle: 'Token #1',
          time: '10:30 AM',
          status: StatusType.confirmed,
          statusLabel: 'Confirmed',
          isDoctor: false,
          onTap: () {},
        ),
      ],
    );
  }
}

class _OnlineSchedule extends StatelessWidget {
  final bool isDark;

  const _OnlineSchedule({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Online Consultation Info
        GlassCard(
          padding: const EdgeInsets.all(16),
          gradient: LinearGradient(
            colors: [
              AppColors.doctorAccent.withOpacity(0.2),
              AppColors.doctorAccent.withOpacity(0.05),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.doctorAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.videocam_rounded, color: AppColors.doctorAccent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Consultations',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '15 min per session',
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
        ),
        const SizedBox(height: 16),
        // Online Time Slots
        Text(
          'Available Slots',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppointmentSlot(time: '06:00 PM', isAvailable: true),
            AppointmentSlot(time: '06:30 PM', isAvailable: true),
            AppointmentSlot(time: '07:00 PM', isSelected: true),
            AppointmentSlot(time: '07:30 PM', isAvailable: true),
            AppointmentSlot(time: '08:00 PM', isAvailable: false),
            AppointmentSlot(time: '08:30 PM', isAvailable: true),
          ],
        ),
        const SizedBox(height: 20),
        // Online Appointments
        AppointmentCard(
          name: 'Rashid Khan',
          subtitle: 'Video Consultation',
          time: '07:00 PM',
          status: StatusType.confirmed,
          statusLabel: 'Confirmed',
          isDoctor: false,
          onTap: () {},
          onVideo: () {},
          onChat: () {},
        ),
      ],
    );
  }
}

/// Patients Tab
class _PatientsTab extends StatelessWidget {
  final bool isDark;

  const _PatientsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Patients',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Search
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search patients...',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Patient List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PatientCard(
                    name: index == 0 ? 'Ahmed Hassan' : 'Fatima Begum',
                    age: index == 0 ? 45 : 32,
                    lastVisit: index == 0 ? 'Today' : '2 days ago',
                    condition: index == 0 ? 'Hypertension' : 'Diabetes',
                    onTap: () {},
                  ),
                );
              },
              childCount: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final int age;
  final String lastVisit;
  final String condition;
  final VoidCallback onTap;

  const _PatientCard({
    required this.name,
    required this.age,
    required this.lastVisit,
    required this.condition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.patientAccent.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                name[0],
                style: TextStyle(
                  color: AppColors.patientAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$age yrs',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                    ),
                    Text(
                      condition,
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Last visit',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  fontSize: 10,
                ),
              ),
              Text(
                lastVisit,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Profile Tab
class _ProfileTab extends StatelessWidget {
  final bool isDark;
  final AuthProvider auth;

  const _ProfileTab({
    required this.isDark,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    final doctorProfile = auth.doctorProfile;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.doctorGradient,
                    border: Border.all(
                      color: AppColors.doctorAccent.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile?.initials ?? 'D',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dr. ${profile?.fullName ?? 'Doctor'}',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctorProfile?.specialization ?? 'Specialist',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${doctorProfile?.rating.toStringAsFixed(1) ?? '0.0'}',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' (${doctorProfile?.totalReviews ?? 0} reviews)',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Settings
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ProfileOption(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.location_on_outlined,
                  label: 'Manage Chambers',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.schedule_outlined,
                  label: 'Schedule Settings',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.payments_outlined,
                  label: 'Fee Settings',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _ProfileOption(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                GlassButton(
                  text: 'Sign Out',
                  icon: Icons.logout_rounded,
                  onPressed: () => _showSignOutDialog(context),
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/intro', (route) => false);
            },
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
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
