import 'models.dart';

/// Medicine Model
class Medicine {
  final String id;
  final String brandName;
  final String genericName;
  final String? manufacturer;
  final String? dosageForm;
  final String? strength;
  final String? packSize;
  final double? price;
  final bool isAvailable;
  final bool requiresPrescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine({
    required this.id,
    required this.brandName,
    required this.genericName,
    this.manufacturer,
    this.dosageForm,
    this.strength,
    this.packSize,
    this.price,
    this.isAvailable = true,
    this.requiresPrescription = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      brandName: json['brand_name'],
      genericName: json['generic_name'],
      manufacturer: json['manufacturer'],
      dosageForm: json['dosage_form'],
      strength: json['strength'],
      packSize: json['pack_size'],
      price: json['price']?.toDouble(),
      isAvailable: json['is_available'] ?? true,
      requiresPrescription: json['requires_prescription'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_name': brandName,
      'generic_name': genericName,
      'manufacturer': manufacturer,
      'dosage_form': dosageForm,
      'strength': strength,
      'pack_size': packSize,
      'price': price,
      'is_available': isAvailable,
      'requires_prescription': requiresPrescription,
    };
  }

  String get displayName =>
      strength != null ? '$brandName $strength' : brandName;
}

/// Prescription Model
class Prescription {
  final String id;
  final String? appointmentId;
  final String patientId;
  final String doctorId;
  final String? diagnosis;
  final List<String> diagnosisIcdCodes;
  final String? bloodPressure;
  final int? pulseRate;
  final double? temperature;
  final double? weightKg;
  final int? spo2;
  final String? advice;
  final DateTime? followUpDate;
  final PrescriptionStatus status;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  List<PrescriptionItem> items;
  PatientProfile? patient;
  DoctorProfile? doctor;

  Prescription({
    required this.id,
    this.appointmentId,
    required this.patientId,
    required this.doctorId,
    this.diagnosis,
    this.diagnosisIcdCodes = const [],
    this.bloodPressure,
    this.pulseRate,
    this.temperature,
    this.weightKg,
    this.spo2,
    this.advice,
    this.followUpDate,
    this.status = PrescriptionStatus.active,
    this.pdfUrl,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
    this.patient,
    this.doctor,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      appointmentId: json['appointment_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      diagnosis: json['diagnosis'],
      diagnosisIcdCodes: json['diagnosis_icd_codes'] != null
          ? List<String>.from(json['diagnosis_icd_codes'])
          : [],
      bloodPressure: json['blood_pressure'],
      pulseRate: json['pulse_rate'],
      temperature: json['temperature']?.toDouble(),
      weightKg: json['weight_kg']?.toDouble(),
      spo2: json['spo2'],
      advice: json['advice'],
      followUpDate: json['follow_up_date'] != null
          ? DateTime.parse(json['follow_up_date'])
          : null,
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PrescriptionStatus.active,
      ),
      pdfUrl: json['pdf_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['prescription_items'] != null
          ? (json['prescription_items'] as List)
              .map((i) => PrescriptionItem.fromJson(i))
              .toList()
          : [],
      patient: json['patient_profiles'] != null
          ? PatientProfile.fromJson(json['patient_profiles'])
          : null,
      doctor: json['doctor_profiles'] != null
          ? DoctorProfile.fromJson(json['doctor_profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'diagnosis': diagnosis,
      'diagnosis_icd_codes': diagnosisIcdCodes,
      'blood_pressure': bloodPressure,
      'pulse_rate': pulseRate,
      'temperature': temperature,
      'weight_kg': weightKg,
      'spo2': spo2,
      'advice': advice,
      'follow_up_date': followUpDate?.toIso8601String().split('T')[0],
      'status': status.name,
    };
  }
}

enum PrescriptionStatus { active, completed, cancelled }

/// Prescription Item Model
class PrescriptionItem {
  final String id;
  final String prescriptionId;
  final String? medicineId;
  final String medicineName;
  final String dosage;
  final String? duration;
  final int? quantity;
  final bool beforeMeal;
  final bool afterMeal;
  final String? instructions;
  final DateTime createdAt;

  // Joined data
  Medicine? medicine;

  PrescriptionItem({
    required this.id,
    required this.prescriptionId,
    this.medicineId,
    required this.medicineName,
    required this.dosage,
    this.duration,
    this.quantity,
    this.beforeMeal = false,
    this.afterMeal = true,
    this.instructions,
    required this.createdAt,
    this.medicine,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      id: json['id'],
      prescriptionId: json['prescription_id'],
      medicineId: json['medicine_id'],
      medicineName: json['medicine_name'],
      dosage: json['dosage'],
      duration: json['duration'],
      quantity: json['quantity'],
      beforeMeal: json['before_meal'] ?? false,
      afterMeal: json['after_meal'] ?? true,
      instructions: json['instructions'],
      createdAt: DateTime.parse(json['created_at']),
      medicine: json['medicines'] != null
          ? Medicine.fromJson(json['medicines'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescription_id': prescriptionId,
      'medicine_id': medicineId,
      'medicine_name': medicineName,
      'dosage': dosage,
      'duration': duration,
      'quantity': quantity,
      'before_meal': beforeMeal,
      'after_meal': afterMeal,
      'instructions': instructions,
    };
  }

  String get mealTiming {
    if (beforeMeal && afterMeal) return 'Before/After meal';
    if (beforeMeal) return 'Before meal';
    if (afterMeal) return 'After meal';
    return 'Any time';
  }
}

/// Medicine Routine Model
class MedicineRoutine {
  final String id;
  final String patientId;
  final String? prescriptionItemId;
  final String medicineName;
  final String dosage;
  final int timesPerDay;
  final List<String> scheduledTimes;
  final List<DayOfWeek> daysOfWeek;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool reminderEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicineRoutine({
    required this.id,
    required this.patientId,
    this.prescriptionItemId,
    required this.medicineName,
    required this.dosage,
    this.timesPerDay = 1,
    this.scheduledTimes = const [],
    this.daysOfWeek = const [],
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.reminderEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicineRoutine.fromJson(Map<String, dynamic> json) {
    return MedicineRoutine(
      id: json['id'],
      patientId: json['patient_id'],
      prescriptionItemId: json['prescription_item_id'],
      medicineName: json['medicine_name'],
      dosage: json['dosage'],
      timesPerDay: json['times_per_day'] ?? 1,
      scheduledTimes: json['scheduled_times'] != null
          ? List<String>.from(json['scheduled_times'])
          : [],
      daysOfWeek: json['days_of_week'] != null
          ? (json['days_of_week'] as List)
              .map((d) => DayOfWeek.fromString(d))
              .toList()
          : [],
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isActive: json['is_active'] ?? true,
      reminderEnabled: json['reminder_enabled'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'prescription_item_id': prescriptionItemId,
      'medicine_name': medicineName,
      'dosage': dosage,
      'times_per_day': timesPerDay,
      'scheduled_times': scheduledTimes,
      'days_of_week': daysOfWeek.map((d) => d.name).toList(),
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'is_active': isActive,
      'reminder_enabled': reminderEnabled,
    };
  }

  bool get isDaily => daysOfWeek.isEmpty;
}

/// Medicine Adherence Model
class MedicineAdherence {
  final String id;
  final String routineId;
  final DateTime scheduledDate;
  final String scheduledTime;
  final DateTime? takenAt;
  final bool isTaken;
  final bool isSkipped;
  final String? skipReason;
  final DateTime createdAt;

  MedicineAdherence({
    required this.id,
    required this.routineId,
    required this.scheduledDate,
    required this.scheduledTime,
    this.takenAt,
    this.isTaken = false,
    this.isSkipped = false,
    this.skipReason,
    required this.createdAt,
  });

  factory MedicineAdherence.fromJson(Map<String, dynamic> json) {
    return MedicineAdherence(
      id: json['id'],
      routineId: json['routine_id'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      scheduledTime: json['scheduled_time'],
      takenAt:
          json['taken_at'] != null ? DateTime.parse(json['taken_at']) : null,
      isTaken: json['is_taken'] ?? false,
      isSkipped: json['is_skipped'] ?? false,
      skipReason: json['skip_reason'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routine_id': routineId,
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      'scheduled_time': scheduledTime,
      'taken_at': takenAt?.toIso8601String(),
      'is_taken': isTaken,
      'is_skipped': isSkipped,
      'skip_reason': skipReason,
    };
  }
}

/// Vital Record Model
class VitalRecord {
  final String id;
  final String patientId;
  final DateTime recordedAt;
  final int? systolicBp;
  final int? diastolicBp;
  final int? heartRate;
  final double? temperature;
  final int? spo2;
  final double? bloodGlucose;
  final double? weightKg;
  final String? notes;
  final String source;
  final DateTime createdAt;

  VitalRecord({
    required this.id,
    required this.patientId,
    required this.recordedAt,
    this.systolicBp,
    this.diastolicBp,
    this.heartRate,
    this.temperature,
    this.spo2,
    this.bloodGlucose,
    this.weightKg,
    this.notes,
    this.source = 'manual',
    required this.createdAt,
  });

  factory VitalRecord.fromJson(Map<String, dynamic> json) {
    return VitalRecord(
      id: json['id'],
      patientId: json['patient_id'],
      recordedAt: DateTime.parse(json['recorded_at']),
      systolicBp: json['systolic_bp'],
      diastolicBp: json['diastolic_bp'],
      heartRate: json['heart_rate'],
      temperature: json['temperature']?.toDouble(),
      spo2: json['spo2'],
      bloodGlucose: json['blood_glucose']?.toDouble(),
      weightKg: json['weight_kg']?.toDouble(),
      notes: json['notes'],
      source: json['source'] ?? 'manual',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'recorded_at': recordedAt.toIso8601String(),
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'heart_rate': heartRate,
      'temperature': temperature,
      'spo2': spo2,
      'blood_glucose': bloodGlucose,
      'weight_kg': weightKg,
      'notes': notes,
      'source': source,
    };
  }

  String? get bloodPressure {
    if (systolicBp != null && diastolicBp != null) {
      return '$systolicBp/$diastolicBp';
    }
    return null;
  }
}

/// Conversation Model
class Conversation {
  final String id;
  final String? appointmentId;
  final String patientId;
  final String doctorId;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;
  final int patientUnreadCount;
  final int doctorUnreadCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  UserProfile? patient;
  UserProfile? doctor;
  List<Message> messages;

  Conversation({
    required this.id,
    this.appointmentId,
    required this.patientId,
    required this.doctorId,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.patientUnreadCount = 0,
    this.doctorUnreadCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
    this.doctor,
    this.messages = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      appointmentId: json['appointment_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      lastMessagePreview: json['last_message_preview'],
      patientUnreadCount: json['patient_unread_count'] ?? 0,
      doctorUnreadCount: json['doctor_unread_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'is_active': isActive,
    };
  }
}

/// Message Model
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  final String messageType;
  final String? attachmentUrl;
  final String? attachmentName;
  final int? attachmentSize;
  final String? prescriptionId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  // Joined data
  UserProfile? sender;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.messageType = 'text',
    this.attachmentUrl,
    this.attachmentName,
    this.attachmentSize,
    this.prescriptionId,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      messageType: json['message_type'] ?? 'text',
      attachmentUrl: json['attachment_url'],
      attachmentName: json['attachment_name'],
      attachmentSize: json['attachment_size'],
      prescriptionId: json['prescription_id'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      sender: json['profiles'] != null
          ? UserProfile.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
      'attachment_url': attachmentUrl,
      'attachment_name': attachmentName,
      'attachment_size': attachmentSize,
      'prescription_id': prescriptionId,
    };
  }

  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isFile => messageType == 'file';
  bool get isVoice => messageType == 'voice';
  bool get isPrescription => messageType == 'prescription';
}

/// Notification Model
class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? appointmentId;
  final String? prescriptionId;
  final String? messageId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? scheduledFor;
  final DateTime? sentAt;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.appointmentId,
    this.prescriptionId,
    this.messageId,
    this.isRead = false,
    this.readAt,
    this.scheduledFor,
    this.sentAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['user_id'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      title: json['title'],
      body: json['body'],
      data: json['data'],
      appointmentId: json['appointment_id'],
      prescriptionId: json['prescription_id'],
      messageId: json['message_id'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      scheduledFor: json['scheduled_for'] != null
          ? DateTime.parse(json['scheduled_for'])
          : null,
      sentAt:
          json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type': type.name,
      'title': title,
      'body': body,
      'data': data,
      'appointment_id': appointmentId,
      'prescription_id': prescriptionId,
      'message_id': messageId,
      'scheduled_for': scheduledFor?.toIso8601String(),
    };
  }
}

enum NotificationType {
  appointment,
  reminder,
  message,
  prescription,
  alert,
  system
}

/// Symptom Check Model (for AI Symptom Checker)
class SymptomCheck {
  final String id;
  final String patientId;
  final List<String> symptoms;
  final String? additionalInfo;
  final String? aiResponse;
  final List<String> possibleConditions;
  final String? urgencyLevel;
  final String? recommendedSpecialization;
  final String? appointmentId;
  final DateTime createdAt;

  SymptomCheck({
    required this.id,
    required this.patientId,
    required this.symptoms,
    this.additionalInfo,
    this.aiResponse,
    this.possibleConditions = const [],
    this.urgencyLevel,
    this.recommendedSpecialization,
    this.appointmentId,
    required this.createdAt,
  });

  factory SymptomCheck.fromJson(Map<String, dynamic> json) {
    return SymptomCheck(
      id: json['id'],
      patientId: json['patient_id'],
      symptoms: List<String>.from(json['symptoms']),
      additionalInfo: json['additional_info'],
      aiResponse: json['ai_response'],
      possibleConditions: json['possible_conditions'] != null
          ? List<String>.from(json['possible_conditions'])
          : [],
      urgencyLevel: json['urgency_level'],
      recommendedSpecialization: json['recommended_specialization'],
      appointmentId: json['appointment_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'symptoms': symptoms,
      'additional_info': additionalInfo,
      'ai_response': aiResponse,
      'possible_conditions': possibleConditions,
      'urgency_level': urgencyLevel,
      'recommended_specialization': recommendedSpecialization,
      'appointment_id': appointmentId,
    };
  }

  bool get isEmergency => urgencyLevel == 'emergency';
  bool get isHighUrgency => urgencyLevel == 'high' || urgencyLevel == 'emergency';
}
