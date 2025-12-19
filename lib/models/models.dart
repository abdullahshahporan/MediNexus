/// MediNexus Data Models
/// Version: 1.0.0

// User Role enum
enum UserRole { patient, doctor, admin }

// Gender enum
enum Gender { male, female, other }

// Blood Group enum
enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative;

  String get display {
    switch (this) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
    }
  }

  static BloodGroup? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'A+':
        return BloodGroup.aPositive;
      case 'A-':
        return BloodGroup.aNegative;
      case 'B+':
        return BloodGroup.bPositive;
      case 'B-':
        return BloodGroup.bNegative;
      case 'AB+':
        return BloodGroup.abPositive;
      case 'AB-':
        return BloodGroup.abNegative;
      case 'O+':
        return BloodGroup.oPositive;
      case 'O-':
        return BloodGroup.oNegative;
      default:
        return null;
    }
  }
}

// Appointment Status enum
enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  noShow;

  String get display {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  static AppointmentStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'no_show':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.pending;
    }
  }
}

// Consultation Type enum
enum ConsultationType {
  inPerson,
  video,
  chat;

  String get display {
    switch (this) {
      case ConsultationType.inPerson:
        return 'In-Person';
      case ConsultationType.video:
        return 'Video Call';
      case ConsultationType.chat:
        return 'Chat';
    }
  }

  static ConsultationType fromString(String value) {
    switch (value) {
      case 'in_person':
        return ConsultationType.inPerson;
      case 'video':
        return ConsultationType.video;
      case 'chat':
        return ConsultationType.chat;
      default:
        return ConsultationType.inPerson;
    }
  }
}

// Day of Week enum
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get display {
    switch (this) {
      case DayOfWeek.monday:
        return 'Monday';
      case DayOfWeek.tuesday:
        return 'Tuesday';
      case DayOfWeek.wednesday:
        return 'Wednesday';
      case DayOfWeek.thursday:
        return 'Thursday';
      case DayOfWeek.friday:
        return 'Friday';
      case DayOfWeek.saturday:
        return 'Saturday';
      case DayOfWeek.sunday:
        return 'Sunday';
    }
  }

  String get short {
    switch (this) {
      case DayOfWeek.monday:
        return 'Mon';
      case DayOfWeek.tuesday:
        return 'Tue';
      case DayOfWeek.wednesday:
        return 'Wed';
      case DayOfWeek.thursday:
        return 'Thu';
      case DayOfWeek.friday:
        return 'Fri';
      case DayOfWeek.saturday:
        return 'Sat';
      case DayOfWeek.sunday:
        return 'Sun';
    }
  }

  static DayOfWeek fromString(String value) {
    return DayOfWeek.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => DayOfWeek.monday,
    );
  }

  static DayOfWeek fromDateTime(DateTime date) {
    return DayOfWeek.values[date.weekday - 1];
  }
}

// Base User Profile
class UserProfile {
  final String id;
  final UserRole role;
  final String email;
  final String? phone;
  final String fullName;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final BloodGroup? bloodGroup;
  final String? address;
  final String? city;
  final String country;
  final String? emergencyContact;
  final String? emergencyPhone;
  final bool faceVerified;
  final bool isActive;
  final String languagePreference;
  final String themePreference;
  final bool notificationEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
    required this.fullName,
    this.displayName,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.city,
    this.country = 'Bangladesh',
    this.emergencyContact,
    this.emergencyPhone,
    this.faceVerified = false,
    this.isActive = true,
    this.languagePreference = 'en',
    this.themePreference = 'dark',
    this.notificationEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.patient,
      ),
      email: json['email'],
      phone: json['phone'],
      fullName: json['full_name'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'] != null
          ? Gender.values.firstWhere((e) => e.name == json['gender'])
          : null,
      bloodGroup: BloodGroup.fromString(json['blood_group']),
      address: json['address'],
      city: json['city'],
      country: json['country'] ?? 'Bangladesh',
      emergencyContact: json['emergency_contact'],
      emergencyPhone: json['emergency_phone'],
      faceVerified: json['face_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      languagePreference: json['language_preference'] ?? 'en',
      themePreference: json['theme_preference'] ?? 'dark',
      notificationEnabled: json['notification_enabled'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender?.name,
      'blood_group': bloodGroup?.display,
      'address': address,
      'city': city,
      'country': country,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'face_verified': faceVerified,
      'is_active': isActive,
      'language_preference': languagePreference,
      'theme_preference': themePreference,
      'notification_enabled': notificationEnabled,
    };
  }

  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}

// Doctor Profile
class DoctorProfile {
  final String id;
  final String userId;
  final String? bmdcRegistration;
  final String specialization;
  final String? subSpecialization;
  final List<String> qualifications;
  final int experienceYears;
  final String? bio;
  final double consultationFee;
  final double followUpFee;
  final double videoConsultationFee;
  final int averageConsultationDuration;
  final bool isOnline;
  final bool isAcceptingAppointments;
  final DateTime? lastOnlineAt;
  final double rating;
  final int totalReviews;
  final int totalPatients;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  UserProfile? user;

  DoctorProfile({
    required this.id,
    required this.userId,
    this.bmdcRegistration,
    required this.specialization,
    this.subSpecialization,
    this.qualifications = const [],
    this.experienceYears = 0,
    this.bio,
    this.consultationFee = 0,
    this.followUpFee = 0,
    this.videoConsultationFee = 0,
    this.averageConsultationDuration = 15,
    this.isOnline = false,
    this.isAcceptingAppointments = true,
    this.lastOnlineAt,
    this.rating = 0,
    this.totalReviews = 0,
    this.totalPatients = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'],
      userId: json['user_id'],
      bmdcRegistration: json['bmdc_registration'],
      specialization: json['specialization'],
      subSpecialization: json['sub_specialization'],
      qualifications: json['qualifications'] != null
          ? List<String>.from(json['qualifications'])
          : [],
      experienceYears: json['experience_years'] ?? 0,
      bio: json['bio'],
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      followUpFee: (json['follow_up_fee'] ?? 0).toDouble(),
      videoConsultationFee: (json['video_consultation_fee'] ?? 0).toDouble(),
      averageConsultationDuration: json['average_consultation_duration'] ?? 15,
      isOnline: json['is_online'] ?? false,
      isAcceptingAppointments: json['is_accepting_appointments'] ?? true,
      lastOnlineAt: json['last_online_at'] != null
          ? DateTime.parse(json['last_online_at'])
          : null,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      totalPatients: json['total_patients'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['profiles'] != null
          ? UserProfile.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bmdc_registration': bmdcRegistration,
      'specialization': specialization,
      'sub_specialization': subSpecialization,
      'qualifications': qualifications,
      'experience_years': experienceYears,
      'bio': bio,
      'consultation_fee': consultationFee,
      'follow_up_fee': followUpFee,
      'video_consultation_fee': videoConsultationFee,
      'average_consultation_duration': averageConsultationDuration,
      'is_online': isOnline,
      'is_accepting_appointments': isAcceptingAppointments,
    };
  }

  String get displayName => user?.displayName ?? user?.fullName ?? 'Doctor';
  String get fullName => user?.fullName ?? 'Doctor';
  String? get avatarUrl => user?.avatarUrl;
}

// Patient Profile
class PatientProfile {
  final String id;
  final String userId;
  final String? medicalHistory;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> currentMedications;
  final double? heightCm;
  final double? weightKg;
  final String? insuranceProvider;
  final String? insurancePolicyNumber;
  final String? primaryDoctorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  UserProfile? user;

  PatientProfile({
    required this.id,
    required this.userId,
    this.medicalHistory,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.currentMedications = const [],
    this.heightCm,
    this.weightKg,
    this.insuranceProvider,
    this.insurancePolicyNumber,
    this.primaryDoctorId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      id: json['id'],
      userId: json['user_id'],
      medicalHistory: json['medical_history'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : [],
      chronicConditions: json['chronic_conditions'] != null
          ? List<String>.from(json['chronic_conditions'])
          : [],
      currentMedications: json['current_medications'] != null
          ? List<String>.from(json['current_medications'])
          : [],
      heightCm: json['height_cm']?.toDouble(),
      weightKg: json['weight_kg']?.toDouble(),
      insuranceProvider: json['insurance_provider'],
      insurancePolicyNumber: json['insurance_policy_number'],
      primaryDoctorId: json['primary_doctor_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['profiles'] != null
          ? UserProfile.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'medical_history': medicalHistory,
      'allergies': allergies,
      'chronic_conditions': chronicConditions,
      'current_medications': currentMedications,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'insurance_provider': insuranceProvider,
      'insurance_policy_number': insurancePolicyNumber,
      'primary_doctor_id': primaryDoctorId,
    };
  }

  String get displayName => user?.displayName ?? user?.fullName ?? 'Patient';
  String get fullName => user?.fullName ?? 'Patient';
  String? get avatarUrl => user?.avatarUrl;

  double? get bmi {
    if (heightCm == null || weightKg == null) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }
}

// Chamber
class Chamber {
  final String id;
  final String doctorId;
  final String name;
  final String address;
  final String city;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool isPrimary;
  final bool isActive;
  final double? consultationFeeOverride;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  List<ChamberSchedule> schedules;

  Chamber({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.address,
    required this.city,
    this.phone,
    this.latitude,
    this.longitude,
    this.isPrimary = false,
    this.isActive = true,
    this.consultationFeeOverride,
    required this.createdAt,
    required this.updatedAt,
    this.schedules = const [],
  });

  factory Chamber.fromJson(Map<String, dynamic> json) {
    return Chamber(
      id: json['id'],
      doctorId: json['doctor_id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      phone: json['phone'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isPrimary: json['is_primary'] ?? false,
      isActive: json['is_active'] ?? true,
      consultationFeeOverride: json['consultation_fee_override']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      schedules: json['chamber_schedules'] != null
          ? (json['chamber_schedules'] as List)
              .map((s) => ChamberSchedule.fromJson(s))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'is_primary': isPrimary,
      'is_active': isActive,
      'consultation_fee_override': consultationFeeOverride,
    };
  }
}

// Chamber Schedule
class ChamberSchedule {
  final String id;
  final String chamberId;
  final DayOfWeek dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDuration;
  final int maxPatients;
  final bool isActive;
  final bool isOnlineSlot;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChamberSchedule({
    required this.id,
    required this.chamberId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.slotDuration = 15,
    this.maxPatients = 20,
    this.isActive = true,
    this.isOnlineSlot = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChamberSchedule.fromJson(Map<String, dynamic> json) {
    return ChamberSchedule(
      id: json['id'],
      chamberId: json['chamber_id'],
      dayOfWeek: DayOfWeek.fromString(json['day_of_week']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      slotDuration: json['slot_duration'] ?? 15,
      maxPatients: json['max_patients'] ?? 20,
      isActive: json['is_active'] ?? true,
      isOnlineSlot: json['is_online_slot'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chamber_id': chamberId,
      'day_of_week': dayOfWeek.name,
      'start_time': startTime,
      'end_time': endTime,
      'slot_duration': slotDuration,
      'max_patients': maxPatients,
      'is_active': isActive,
      'is_online_slot': isOnlineSlot,
    };
  }
}

// Appointment
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String? chamberId;
  final DateTime appointmentDate;
  final String startTime;
  final String? endTime;
  final ConsultationType consultationType;
  final AppointmentStatus status;
  final int? tokenNumber;
  final int? queuePosition;
  final String? reasonForVisit;
  final List<String> symptoms;
  final String? notes;
  final double? consultationFee;
  final bool isPaid;
  final String? paymentId;
  final String? videoRoomId;
  final String? videoRoomUrl;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  PatientProfile? patient;
  DoctorProfile? doctor;
  Chamber? chamber;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.chamberId,
    required this.appointmentDate,
    required this.startTime,
    this.endTime,
    this.consultationType = ConsultationType.inPerson,
    this.status = AppointmentStatus.pending,
    this.tokenNumber,
    this.queuePosition,
    this.reasonForVisit,
    this.symptoms = const [],
    this.notes,
    this.consultationFee,
    this.isPaid = false,
    this.paymentId,
    this.videoRoomId,
    this.videoRoomUrl,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
    this.doctor,
    this.chamber,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      chamberId: json['chamber_id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      consultationType:
          ConsultationType.fromString(json['consultation_type'] ?? 'in_person'),
      status: AppointmentStatus.fromString(json['status'] ?? 'pending'),
      tokenNumber: json['token_number'],
      queuePosition: json['queue_position'],
      reasonForVisit: json['reason_for_visit'],
      symptoms:
          json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
      notes: json['notes'],
      consultationFee: json['consultation_fee']?.toDouble(),
      isPaid: json['is_paid'] ?? false,
      paymentId: json['payment_id'],
      videoRoomId: json['video_room_id'],
      videoRoomUrl: json['video_room_url'],
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'])
          : null,
      startedAt:
          json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      cancellationReason: json['cancellation_reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      patient: json['patient_profiles'] != null
          ? PatientProfile.fromJson(json['patient_profiles'])
          : null,
      doctor: json['doctor_profiles'] != null
          ? DoctorProfile.fromJson(json['doctor_profiles'])
          : null,
      chamber:
          json['chambers'] != null ? Chamber.fromJson(json['chambers']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'chamber_id': chamberId,
      'appointment_date': appointmentDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'consultation_type': consultationType.name,
      'status': status.name,
      'token_number': tokenNumber,
      'queue_position': queuePosition,
      'reason_for_visit': reasonForVisit,
      'symptoms': symptoms,
      'notes': notes,
      'consultation_fee': consultationFee,
      'is_paid': isPaid,
      'payment_id': paymentId,
    };
  }

  bool get isUpcoming =>
      appointmentDate.isAfter(DateTime.now()) ||
      (appointmentDate.day == DateTime.now().day &&
          status != AppointmentStatus.completed &&
          status != AppointmentStatus.cancelled);

  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }
}
