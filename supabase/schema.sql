-- ============================================
-- MediNexus Database Schema for Supabase
-- Version: 1.0.0
-- ============================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- ENUMS
-- ============================================

CREATE TYPE user_role AS ENUM ('patient', 'doctor', 'admin');
CREATE TYPE gender_type AS ENUM ('male', 'female', 'other');
CREATE TYPE appointment_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled', 'no_show');
CREATE TYPE consultation_type AS ENUM ('in_person', 'video', 'chat');
CREATE TYPE prescription_status AS ENUM ('active', 'completed', 'cancelled');
CREATE TYPE chamber_day AS ENUM ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday');
CREATE TYPE notification_type AS ENUM ('appointment', 'reminder', 'message', 'prescription', 'alert', 'system');
CREATE TYPE blood_group_type AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-');

-- ============================================
-- USERS & PROFILES
-- ============================================

-- Main users table (extends Supabase auth.users)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role user_role NOT NULL DEFAULT 'patient',
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    full_name TEXT NOT NULL,
    display_name TEXT,
    avatar_url TEXT,
    date_of_birth DATE,
    gender gender_type,
    blood_group blood_group_type,
    address TEXT,
    city TEXT,
    country TEXT DEFAULT 'Bangladesh',
    emergency_contact TEXT,
    emergency_phone TEXT,
    face_encoding TEXT, -- For face recognition (stored as base64)
    face_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    language_preference TEXT DEFAULT 'en', -- 'en' or 'bn'
    theme_preference TEXT DEFAULT 'dark', -- 'dark' or 'light'
    notification_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Doctor-specific profile extension
CREATE TABLE public.doctor_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Professional Info
    bmdc_registration TEXT UNIQUE, -- Bangladesh Medical & Dental Council
    specialization TEXT NOT NULL,
    sub_specialization TEXT,
    qualifications TEXT[], -- Array of qualifications
    experience_years INTEGER DEFAULT 0,
    bio TEXT,
    
    -- Consultation Settings
    consultation_fee DECIMAL(10, 2) DEFAULT 0,
    follow_up_fee DECIMAL(10, 2) DEFAULT 0,
    video_consultation_fee DECIMAL(10, 2) DEFAULT 0,
    average_consultation_duration INTEGER DEFAULT 15, -- in minutes
    
    -- Status
    is_online BOOLEAN DEFAULT FALSE,
    is_accepting_appointments BOOLEAN DEFAULT TRUE,
    last_online_at TIMESTAMPTZ,
    
    -- Ratings
    rating DECIMAL(3, 2) DEFAULT 0,
    total_reviews INTEGER DEFAULT 0,
    total_patients INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Patient-specific profile extension
CREATE TABLE public.patient_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Medical Info
    medical_history TEXT,
    allergies TEXT[],
    chronic_conditions TEXT[],
    current_medications TEXT[],
    height_cm DECIMAL(5, 2),
    weight_kg DECIMAL(5, 2),
    
    -- Insurance Info
    insurance_provider TEXT,
    insurance_policy_number TEXT,
    
    -- Family Doctor
    primary_doctor_id UUID REFERENCES public.doctor_profiles(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- CHAMBERS & SCHEDULE
-- ============================================

-- Doctor's chambers/clinics
CREATE TABLE public.chambers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES public.doctor_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    phone TEXT,
    
    -- Location for map
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Settings
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    consultation_fee_override DECIMAL(10, 2), -- If different from default
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chamber schedule/time slots
CREATE TABLE public.chamber_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chamber_id UUID NOT NULL REFERENCES public.chambers(id) ON DELETE CASCADE,
    day_of_week chamber_day NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_duration INTEGER DEFAULT 15, -- in minutes
    max_patients INTEGER DEFAULT 20,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- For online consultations
    is_online_slot BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(chamber_id, day_of_week, start_time, is_online_slot)
);

-- Doctor's unavailable dates (leaves, holidays)
CREATE TABLE public.doctor_unavailability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES public.doctor_profiles(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    chamber_id UUID REFERENCES public.chambers(id), -- If null, affects all chambers
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- APPOINTMENTS
-- ============================================

CREATE TABLE public.appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Parties
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id),
    doctor_id UUID NOT NULL REFERENCES public.doctor_profiles(id),
    chamber_id UUID REFERENCES public.chambers(id),
    
    -- Timing
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME,
    
    -- Type & Status
    consultation_type consultation_type DEFAULT 'in_person',
    status appointment_status DEFAULT 'pending',
    
    -- Queue
    token_number INTEGER,
    queue_position INTEGER,
    
    -- Details
    reason_for_visit TEXT,
    symptoms TEXT[],
    notes TEXT,
    
    -- Fees
    consultation_fee DECIMAL(10, 2),
    is_paid BOOLEAN DEFAULT FALSE,
    payment_id TEXT,
    
    -- Video Call
    video_room_id TEXT,
    video_room_url TEXT,
    
    -- Timestamps
    confirmed_at TIMESTAMPTZ,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PRESCRIPTIONS & MEDICINES
-- ============================================

-- Medicine database (can be seeded from medex.com.bd data)
CREATE TABLE public.medicines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_name TEXT NOT NULL,
    generic_name TEXT NOT NULL,
    manufacturer TEXT,
    dosage_form TEXT, -- tablet, capsule, syrup, injection, etc.
    strength TEXT, -- 500mg, 250mg/5ml, etc.
    pack_size TEXT,
    price DECIMAL(10, 2),
    is_available BOOLEAN DEFAULT TRUE,
    requires_prescription BOOLEAN DEFAULT TRUE,
    
    -- Search optimization
    search_vector TSVECTOR,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for medicine search
CREATE INDEX medicines_search_idx ON public.medicines USING GIN(search_vector);

-- Prescriptions
CREATE TABLE public.prescriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID REFERENCES public.appointments(id),
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id),
    doctor_id UUID NOT NULL REFERENCES public.doctor_profiles(id),
    
    -- Diagnosis
    diagnosis TEXT,
    diagnosis_icd_codes TEXT[], -- ICD-10 codes
    
    -- Vitals at time of prescription
    blood_pressure TEXT,
    pulse_rate INTEGER,
    temperature DECIMAL(4, 1),
    weight_kg DECIMAL(5, 2),
    spo2 INTEGER,
    
    -- Additional Notes
    advice TEXT,
    follow_up_date DATE,
    
    -- Status
    status prescription_status DEFAULT 'active',
    
    -- PDF Storage
    pdf_url TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Prescription items (medicines)
CREATE TABLE public.prescription_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prescription_id UUID NOT NULL REFERENCES public.prescriptions(id) ON DELETE CASCADE,
    medicine_id UUID REFERENCES public.medicines(id),
    
    -- If medicine not in database
    medicine_name TEXT NOT NULL,
    
    -- Dosage instructions
    dosage TEXT NOT NULL, -- "1+0+1", "1 tablet twice daily"
    duration TEXT, -- "7 days", "2 weeks"
    quantity INTEGER,
    
    -- Timing
    before_meal BOOLEAN DEFAULT FALSE,
    after_meal BOOLEAN DEFAULT TRUE,
    
    -- Additional instructions
    instructions TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PATIENT ROUTINES & REMINDERS
-- ============================================

-- Medicine routines for patients
CREATE TABLE public.medicine_routines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id) ON DELETE CASCADE,
    prescription_item_id UUID REFERENCES public.prescription_items(id),
    
    medicine_name TEXT NOT NULL,
    dosage TEXT NOT NULL,
    
    -- Schedule
    times_per_day INTEGER DEFAULT 1,
    scheduled_times TIME[], -- Array of times
    days_of_week chamber_day[], -- If empty, daily
    
    start_date DATE NOT NULL,
    end_date DATE,
    
    is_active BOOLEAN DEFAULT TRUE,
    reminder_enabled BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medicine adherence tracking
CREATE TABLE public.medicine_adherence (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    routine_id UUID NOT NULL REFERENCES public.medicine_routines(id) ON DELETE CASCADE,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    
    taken_at TIMESTAMPTZ,
    is_taken BOOLEAN DEFAULT FALSE,
    is_skipped BOOLEAN DEFAULT FALSE,
    skip_reason TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(routine_id, scheduled_date, scheduled_time)
);

-- ============================================
-- VITAL SIGNS TRACKING
-- ============================================

CREATE TABLE public.vital_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id) ON DELETE CASCADE,
    
    recorded_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Vitals
    systolic_bp INTEGER,
    diastolic_bp INTEGER,
    heart_rate INTEGER,
    temperature DECIMAL(4, 1),
    spo2 INTEGER,
    blood_glucose DECIMAL(5, 1),
    weight_kg DECIMAL(5, 2),
    
    -- Notes
    notes TEXT,
    
    -- Source
    source TEXT DEFAULT 'manual', -- 'manual', 'device', 'doctor'
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- MESSAGING
-- ============================================

-- Chat conversations
CREATE TABLE public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID REFERENCES public.appointments(id),
    patient_id UUID NOT NULL REFERENCES public.profiles(id),
    doctor_id UUID NOT NULL REFERENCES public.profiles(id),
    
    last_message_at TIMESTAMPTZ,
    last_message_preview TEXT,
    
    -- Unread counts
    patient_unread_count INTEGER DEFAULT 0,
    doctor_unread_count INTEGER DEFAULT 0,
    
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat messages
CREATE TABLE public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id),
    
    content TEXT,
    message_type TEXT DEFAULT 'text', -- 'text', 'image', 'file', 'voice', 'prescription'
    
    -- Attachments
    attachment_url TEXT,
    attachment_name TEXT,
    attachment_size INTEGER,
    
    -- For prescription sharing
    prescription_id UUID REFERENCES public.prescriptions(id),
    
    -- Status
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB, -- Additional data for deep linking
    
    -- References
    appointment_id UUID REFERENCES public.appointments(id),
    prescription_id UUID REFERENCES public.prescriptions(id),
    message_id UUID REFERENCES public.messages(id),
    
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMPTZ,
    
    -- For scheduled notifications
    scheduled_for TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- REVIEWS & RATINGS
-- ============================================

CREATE TABLE public.doctor_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES public.doctor_profiles(id) ON DELETE CASCADE,
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id),
    appointment_id UUID REFERENCES public.appointments(id),
    
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    
    -- Detailed ratings
    punctuality_rating INTEGER CHECK (punctuality_rating >= 1 AND punctuality_rating <= 5),
    communication_rating INTEGER CHECK (communication_rating >= 1 AND communication_rating <= 5),
    treatment_rating INTEGER CHECK (treatment_rating >= 1 AND treatment_rating <= 5),
    
    is_anonymous BOOLEAN DEFAULT FALSE,
    is_visible BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(appointment_id)
);

-- ============================================
-- AI SYMPTOM CHECKER
-- ============================================

CREATE TABLE public.symptom_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES public.patient_profiles(id) ON DELETE CASCADE,
    
    symptoms TEXT[] NOT NULL,
    additional_info TEXT,
    
    -- AI Analysis (from Grok)
    ai_response TEXT,
    possible_conditions TEXT[],
    urgency_level TEXT, -- 'low', 'medium', 'high', 'emergency'
    recommended_specialization TEXT,
    
    -- If converted to appointment
    appointment_id UUID REFERENCES public.appointments(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- VIEWS
-- ============================================

-- Doctor dashboard view
CREATE VIEW public.doctor_dashboard_view AS
SELECT 
    dp.id as doctor_profile_id,
    dp.user_id,
    p.full_name,
    p.avatar_url,
    dp.specialization,
    dp.is_online,
    dp.rating,
    dp.total_patients,
    (SELECT COUNT(*) FROM public.appointments a 
     WHERE a.doctor_id = dp.id 
     AND a.appointment_date = CURRENT_DATE 
     AND a.status IN ('pending', 'confirmed')) as today_appointments,
    (SELECT COUNT(*) FROM public.appointments a 
     WHERE a.doctor_id = dp.id 
     AND a.status = 'pending') as pending_appointments,
    (SELECT COUNT(*) FROM public.conversations c 
     WHERE c.doctor_id = p.id 
     AND c.doctor_unread_count > 0) as unread_messages
FROM public.doctor_profiles dp
JOIN public.profiles p ON dp.user_id = p.id;

-- Patient dashboard view  
CREATE VIEW public.patient_dashboard_view AS
SELECT 
    pp.id as patient_profile_id,
    pp.user_id,
    p.full_name,
    p.avatar_url,
    (SELECT COUNT(*) FROM public.appointments a 
     WHERE a.patient_id = pp.id 
     AND a.appointment_date >= CURRENT_DATE 
     AND a.status IN ('pending', 'confirmed')) as upcoming_appointments,
    (SELECT COUNT(*) FROM public.prescriptions pr 
     WHERE pr.patient_id = pp.id 
     AND pr.status = 'active') as active_prescriptions,
    (SELECT COUNT(*) FROM public.medicine_routines mr 
     WHERE mr.patient_id = pp.id 
     AND mr.is_active = TRUE) as active_routines,
    (SELECT COUNT(*) FROM public.conversations c 
     WHERE c.patient_id = p.id 
     AND c.patient_unread_count > 0) as unread_messages
FROM public.patient_profiles pp
JOIN public.profiles p ON pp.user_id = p.id;

-- ============================================
-- FUNCTIONS
-- ============================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Update medicine search vector
CREATE OR REPLACE FUNCTION update_medicine_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector := 
        setweight(to_tsvector('english', COALESCE(NEW.brand_name, '')), 'A') ||
        setweight(to_tsvector('english', COALESCE(NEW.generic_name, '')), 'A') ||
        setweight(to_tsvector('english', COALESCE(NEW.manufacturer, '')), 'B');
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Update doctor rating after review
CREATE OR REPLACE FUNCTION update_doctor_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.doctor_profiles
    SET 
        rating = (SELECT AVG(rating) FROM public.doctor_reviews WHERE doctor_id = NEW.doctor_id AND is_visible = TRUE),
        total_reviews = (SELECT COUNT(*) FROM public.doctor_reviews WHERE doctor_id = NEW.doctor_id AND is_visible = TRUE)
    WHERE id = NEW.doctor_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- ============================================
-- TRIGGERS
-- ============================================

-- Updated_at triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_profiles_updated_at BEFORE UPDATE ON public.doctor_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_profiles_updated_at BEFORE UPDATE ON public.patient_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chambers_updated_at BEFORE UPDATE ON public.chambers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON public.appointments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prescriptions_updated_at BEFORE UPDATE ON public.prescriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_medicine_routines_updated_at BEFORE UPDATE ON public.medicine_routines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON public.conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Medicine search vector trigger
CREATE TRIGGER update_medicines_search_vector BEFORE INSERT OR UPDATE ON public.medicines
    FOR EACH ROW EXECUTE FUNCTION update_medicine_search_vector();

-- Doctor rating trigger
CREATE TRIGGER update_doctor_rating_trigger AFTER INSERT OR UPDATE ON public.doctor_reviews
    FOR EACH ROW EXECUTE FUNCTION update_doctor_rating();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctor_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patient_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chambers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chamber_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prescriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prescription_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medicine_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medicine_adherence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vital_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctor_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.symptom_checks ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles
    FOR SELECT USING (TRUE);

-- Doctor profiles policies
CREATE POLICY "Doctors can manage their own profile" ON public.doctor_profiles
    FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Anyone can view doctor profiles" ON public.doctor_profiles
    FOR SELECT USING (TRUE);

-- Patient profiles policies
CREATE POLICY "Patients can manage their own profile" ON public.patient_profiles
    FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Doctors can view their patients" ON public.patient_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.appointments a
            JOIN public.doctor_profiles dp ON a.doctor_id = dp.id
            WHERE dp.user_id = auth.uid()
            AND a.patient_id = patient_profiles.id
        )
    );

-- Appointments policies
CREATE POLICY "Patients can view their own appointments" ON public.appointments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.patient_profiles pp
            WHERE pp.id = appointments.patient_id
            AND pp.user_id = auth.uid()
        )
    );

CREATE POLICY "Doctors can view their own appointments" ON public.appointments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.doctor_profiles dp
            WHERE dp.id = appointments.doctor_id
            AND dp.user_id = auth.uid()
        )
    );

-- Notifications policies
CREATE POLICY "Users can view their own notifications" ON public.notifications
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can update their own notifications" ON public.notifications
    FOR UPDATE USING (user_id = auth.uid());

-- Messages policies
CREATE POLICY "Users can view messages in their conversations" ON public.messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.conversations c
            WHERE c.id = messages.conversation_id
            AND (c.patient_id = auth.uid() OR c.doctor_id = auth.uid())
        )
    );

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_doctor_profiles_specialization ON public.doctor_profiles(specialization);
CREATE INDEX idx_doctor_profiles_is_online ON public.doctor_profiles(is_online);
CREATE INDEX idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX idx_appointments_status ON public.appointments(status);
CREATE INDEX idx_appointments_doctor ON public.appointments(doctor_id);
CREATE INDEX idx_appointments_patient ON public.appointments(patient_id);
CREATE INDEX idx_prescriptions_patient ON public.prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor ON public.prescriptions(doctor_id);
CREATE INDEX idx_medicine_routines_patient ON public.medicine_routines(patient_id);
CREATE INDEX idx_conversations_patient ON public.conversations(patient_id);
CREATE INDEX idx_conversations_doctor ON public.conversations(doctor_id);
CREATE INDEX idx_messages_conversation ON public.messages(conversation_id);
CREATE INDEX idx_notifications_user ON public.notifications(user_id);
CREATE INDEX idx_notifications_unread ON public.notifications(user_id, is_read);

-- ============================================
-- SEED DATA (Optional - Sample Specializations)
-- ============================================

-- INSERT INTO public.medicines (brand_name, generic_name, manufacturer, dosage_form, strength) VALUES
-- ('Napa', 'Paracetamol', 'Beximco Pharma', 'Tablet', '500mg'),
-- ('Napa Extra', 'Paracetamol + Caffeine', 'Beximco Pharma', 'Tablet', '500mg+65mg'),
-- ('Seclo', 'Omeprazole', 'Square Pharma', 'Capsule', '20mg'),
-- ('Zimax', 'Azithromycin', 'Square Pharma', 'Tablet', '500mg'),
-- ('Monas', 'Montelukast', 'Square Pharma', 'Tablet', '10mg');

COMMENT ON SCHEMA public IS 'MediNexus Healthcare Management System Database Schema';
