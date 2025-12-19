-- =====================================================
-- MediNexus Database Schema for Supabase
-- =====================================================
-- This script creates all necessary tables, indexes, RLS policies
-- and functions for the MediNexus healthcare application
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- ENUMS
-- =====================================================

-- User role enum
CREATE TYPE user_role AS ENUM ('patient', 'doctor', 'admin');

-- Gender enum
CREATE TYPE gender AS ENUM ('male', 'female', 'other');

-- Appointment status enum
CREATE TYPE appointment_status AS ENUM ('scheduled', 'completed', 'cancelled', 'no_show');

-- Prescription status enum
CREATE TYPE prescription_status AS ENUM ('active', 'completed', 'cancelled');

-- =====================================================
-- TABLES
-- =====================================================

-- Profiles table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role user_role NOT NULL DEFAULT 'patient',
  phone TEXT,
  date_of_birth DATE,
  gender gender,
  blood_group TEXT,
  address TEXT,
  city TEXT,
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Doctor profiles table
CREATE TABLE IF NOT EXISTS doctor_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  specialization TEXT NOT NULL DEFAULT 'General',
  bmdc_registration TEXT UNIQUE,
  qualifications TEXT[] DEFAULT '{}',
  experience_years INTEGER DEFAULT 0,
  consultation_fee DECIMAL(10,2) DEFAULT 0,
  bio TEXT,
  consultation_duration INTEGER DEFAULT 30, -- in minutes
  rating DECIMAL(3,2) DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  total_patients INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Patient profiles table
CREATE TABLE IF NOT EXISTS patient_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  emergency_contact TEXT,
  emergency_phone TEXT,
  allergies TEXT[] DEFAULT '{}',
  chronic_conditions TEXT[] DEFAULT '{}',
  current_medications TEXT[] DEFAULT '{}',
  insurance_provider TEXT,
  insurance_number TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  duration INTEGER DEFAULT 30, -- in minutes
  status appointment_status DEFAULT 'scheduled',
  reason TEXT,
  notes TEXT,
  consultation_fee DECIMAL(10,2),
  payment_status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Prescriptions table
CREATE TABLE IF NOT EXISTS prescriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  patient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  diagnosis TEXT,
  symptoms TEXT,
  notes TEXT,
  follow_up_date DATE,
  status prescription_status DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medications table (part of prescription)
CREATE TABLE IF NOT EXISTS medications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
  medicine_name TEXT NOT NULL,
  dosage TEXT NOT NULL,
  frequency TEXT NOT NULL,
  duration TEXT NOT NULL,
  instructions TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Lab tests table (part of prescription)
CREATE TABLE IF NOT EXISTS lab_tests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
  test_name TEXT NOT NULL,
  instructions TEXT,
  status TEXT DEFAULT 'pending',
  result TEXT,
  result_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medical records table
CREATE TABLE IF NOT EXISTS medical_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  record_type TEXT NOT NULL, -- 'lab_report', 'imaging', 'prescription', 'note'
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT,
  record_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Doctor reviews table
CREATE TABLE IF NOT EXISTS doctor_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  patient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(appointment_id)
);

-- Doctor availability table
CREATE TABLE IF NOT EXISTS doctor_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday, 6=Saturday
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(doctor_id, day_of_week, start_time)
);

-- Doctor off days table (for specific dates when doctor is not available)
CREATE TABLE IF NOT EXISTS doctor_off_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  off_date DATE NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(doctor_id, off_date)
);

-- Chat conversations table
CREATE TABLE IF NOT EXISTS conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  last_message TEXT,
  last_message_time TIMESTAMPTZ,
  unread_count_patient INTEGER DEFAULT 0,
  unread_count_doctor INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(patient_id, doctor_id)
);

-- Chat messages table
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  attachment_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL, -- 'appointment', 'prescription', 'message', 'reminder'
  is_read BOOLEAN DEFAULT FALSE,
  reference_id UUID, -- ID of related appointment, prescription, etc.
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- INDEXES
-- =====================================================

-- Profiles indexes
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

-- Doctor profiles indexes
CREATE INDEX IF NOT EXISTS idx_doctor_profiles_user_id ON doctor_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_doctor_profiles_specialization ON doctor_profiles(specialization);
CREATE INDEX IF NOT EXISTS idx_doctor_profiles_rating ON doctor_profiles(rating DESC);

-- Patient profiles indexes
CREATE INDEX IF NOT EXISTS idx_patient_profiles_user_id ON patient_profiles(user_id);

-- Appointments indexes
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);

-- Prescriptions indexes
CREATE INDEX IF NOT EXISTS idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_appointment_id ON prescriptions(appointment_id);

-- Medications indexes
CREATE INDEX IF NOT EXISTS idx_medications_prescription_id ON medications(prescription_id);

-- Lab tests indexes
CREATE INDEX IF NOT EXISTS idx_lab_tests_prescription_id ON lab_tests(prescription_id);

-- Medical records indexes
CREATE INDEX IF NOT EXISTS idx_medical_records_patient_id ON medical_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_doctor_id ON medical_records(doctor_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_record_date ON medical_records(record_date DESC);

-- Doctor reviews indexes
CREATE INDEX IF NOT EXISTS idx_doctor_reviews_doctor_id ON doctor_reviews(doctor_id);
CREATE INDEX IF NOT EXISTS idx_doctor_reviews_patient_id ON doctor_reviews(patient_id);

-- Doctor availability indexes
CREATE INDEX IF NOT EXISTS idx_doctor_availability_doctor_id ON doctor_availability(doctor_id);

-- Messages indexes
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);

-- Conversations indexes
CREATE INDEX IF NOT EXISTS idx_conversations_patient_id ON conversations(patient_id);
CREATE INDEX IF NOT EXISTS idx_conversations_doctor_id ON conversations(doctor_id);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update doctor rating
CREATE OR REPLACE FUNCTION update_doctor_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE doctor_profiles
  SET 
    rating = (
      SELECT AVG(rating)::DECIMAL(3,2)
      FROM doctor_reviews
      WHERE doctor_id = NEW.doctor_id
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM doctor_reviews
      WHERE doctor_id = NEW.doctor_id
    )
  WHERE user_id = NEW.doctor_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update conversation on new message
CREATE OR REPLACE FUNCTION update_conversation_on_message()
RETURNS TRIGGER AS $$
DECLARE
  patient_id_var UUID;
  doctor_id_var UUID;
BEGIN
  -- Get patient and doctor IDs from conversation
  SELECT patient_id, doctor_id INTO patient_id_var, doctor_id_var
  FROM conversations
  WHERE id = NEW.conversation_id;
  
  -- Update conversation
  UPDATE conversations
  SET 
    last_message = NEW.message_text,
    last_message_time = NEW.created_at,
    unread_count_patient = CASE 
      WHEN NEW.sender_id = doctor_id_var THEN unread_count_patient + 1 
      ELSE unread_count_patient 
    END,
    unread_count_doctor = CASE 
      WHEN NEW.sender_id = patient_id_var THEN unread_count_doctor + 1 
      ELSE unread_count_doctor 
    END,
    updated_at = NOW()
  WHERE id = NEW.conversation_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Updated_at triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_profiles_updated_at BEFORE UPDATE ON doctor_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_profiles_updated_at BEFORE UPDATE ON patient_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON appointments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prescriptions_updated_at BEFORE UPDATE ON prescriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_medical_records_updated_at BEFORE UPDATE ON medical_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_reviews_updated_at BEFORE UPDATE ON doctor_reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON conversations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Doctor rating update trigger
CREATE TRIGGER update_doctor_rating_trigger AFTER INSERT OR UPDATE ON doctor_reviews
  FOR EACH ROW EXECUTE FUNCTION update_doctor_rating();

-- Conversation update trigger
CREATE TRIGGER update_conversation_trigger AFTER INSERT ON messages
  FOR EACH ROW EXECUTE FUNCTION update_conversation_on_message();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE patient_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE lab_tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_off_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view all doctor profiles" ON profiles
  FOR SELECT USING (role = 'doctor');

CREATE POLICY "Users can insert their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Doctor profiles policies
CREATE POLICY "Anyone can view doctor profiles" ON doctor_profiles
  FOR SELECT USING (true);

CREATE POLICY "Doctors can update their own profile" ON doctor_profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Doctors can insert their own profile" ON doctor_profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Patient profiles policies
CREATE POLICY "Patients can view their own profile" ON patient_profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Patients can update their own profile" ON patient_profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Doctors can view patient profiles" ON patient_profiles
  FOR SELECT USING (
    auth.uid() IN (
      SELECT doctor_id FROM appointments WHERE patient_id = user_id
    )
  );

CREATE POLICY "Patients can insert their own profile" ON patient_profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Appointments policies
CREATE POLICY "Users can view their own appointments" ON appointments
  FOR SELECT USING (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

CREATE POLICY "Patients can create appointments" ON appointments
  FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Users can update their own appointments" ON appointments
  FOR UPDATE USING (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

-- Prescriptions policies
CREATE POLICY "Users can view their own prescriptions" ON prescriptions
  FOR SELECT USING (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

CREATE POLICY "Doctors can create prescriptions" ON prescriptions
  FOR INSERT WITH CHECK (auth.uid() = doctor_id);

CREATE POLICY "Doctors can update their prescriptions" ON prescriptions
  FOR UPDATE USING (auth.uid() = doctor_id);

-- Medications policies
CREATE POLICY "Users can view medications of their prescriptions" ON medications
  FOR SELECT USING (
    prescription_id IN (
      SELECT id FROM prescriptions 
      WHERE patient_id = auth.uid() OR doctor_id = auth.uid()
    )
  );

CREATE POLICY "Doctors can insert medications" ON medications
  FOR INSERT WITH CHECK (
    prescription_id IN (
      SELECT id FROM prescriptions WHERE doctor_id = auth.uid()
    )
  );

-- Lab tests policies
CREATE POLICY "Users can view lab tests of their prescriptions" ON lab_tests
  FOR SELECT USING (
    prescription_id IN (
      SELECT id FROM prescriptions 
      WHERE patient_id = auth.uid() OR doctor_id = auth.uid()
    )
  );

CREATE POLICY "Doctors can insert lab tests" ON lab_tests
  FOR INSERT WITH CHECK (
    prescription_id IN (
      SELECT id FROM prescriptions WHERE doctor_id = auth.uid()
    )
  );

CREATE POLICY "Doctors can update lab tests" ON lab_tests
  FOR UPDATE USING (
    prescription_id IN (
      SELECT id FROM prescriptions WHERE doctor_id = auth.uid()
    )
  );

-- Medical records policies
CREATE POLICY "Patients can view their own records" ON medical_records
  FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Doctors can view records of their patients" ON medical_records
  FOR SELECT USING (
    auth.uid() IN (
      SELECT doctor_id FROM appointments WHERE patient_id = medical_records.patient_id
    )
  );

CREATE POLICY "Users can create their own records" ON medical_records
  FOR INSERT WITH CHECK (auth.uid() = patient_id OR auth.uid() = doctor_id);

CREATE POLICY "Users can update their own records" ON medical_records
  FOR UPDATE USING (auth.uid() = patient_id OR auth.uid() = doctor_id);

-- Doctor reviews policies
CREATE POLICY "Anyone can view doctor reviews" ON doctor_reviews
  FOR SELECT USING (true);

CREATE POLICY "Patients can create reviews" ON doctor_reviews
  FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Patients can update their own reviews" ON doctor_reviews
  FOR UPDATE USING (auth.uid() = patient_id);

-- Doctor availability policies
CREATE POLICY "Anyone can view doctor availability" ON doctor_availability
  FOR SELECT USING (true);

CREATE POLICY "Doctors can manage their availability" ON doctor_availability
  FOR ALL USING (auth.uid() = doctor_id);

-- Doctor off days policies
CREATE POLICY "Anyone can view doctor off days" ON doctor_off_days
  FOR SELECT USING (true);

CREATE POLICY "Doctors can manage their off days" ON doctor_off_days
  FOR ALL USING (auth.uid() = doctor_id);

-- Conversations policies
CREATE POLICY "Users can view their own conversations" ON conversations
  FOR SELECT USING (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

CREATE POLICY "Users can create conversations" ON conversations
  FOR INSERT WITH CHECK (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

CREATE POLICY "Users can update their own conversations" ON conversations
  FOR UPDATE USING (
    auth.uid() = patient_id OR auth.uid() = doctor_id
  );

-- Messages policies
CREATE POLICY "Users can view messages in their conversations" ON messages
  FOR SELECT USING (
    conversation_id IN (
      SELECT id FROM conversations 
      WHERE patient_id = auth.uid() OR doctor_id = auth.uid()
    )
  );

CREATE POLICY "Users can send messages in their conversations" ON messages
  FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    conversation_id IN (
      SELECT id FROM conversations 
      WHERE patient_id = auth.uid() OR doctor_id = auth.uid()
    )
  );

-- Notifications policies
CREATE POLICY "Users can view their own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "System can create notifications" ON notifications
  FOR INSERT WITH CHECK (true);

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Note: You can add sample data here for testing purposes
-- Make sure to remove or comment out before production deployment

-- =====================================================
-- END OF SCHEMA
-- =====================================================
