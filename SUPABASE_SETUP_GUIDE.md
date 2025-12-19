# MediNexus Supabase Setup Guide

## Prerequisites
- Supabase account (https://supabase.com)
- MediNexus Flutter app installed

## Step 1: Create Supabase Project

1. Go to https://supabase.com and sign in
2. Click "New Project"
3. Fill in:
   - **Project Name**: MediNexus
   - **Database Password**: Choose a strong password (save this!)
   - **Region**: Select closest to your users
4. Click "Create new project" and wait for setup to complete

## Step 2: Get API Credentials

1. In your Supabase project dashboard, go to **Settings** > **API**
2. Copy the following values:
   - **Project URL** (starts with https://xxxxx.supabase.co)
   - **anon/public key** (long string starting with eyJ...)

## Step 3: Configure Flutter App

1. Create a `.env` file in the root of your Flutter project:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
GROK_API_KEY=your-grok-api-key-here
```

2. Update `lib/config/supabase_config.dart` if needed (it should read from .env automatically)

## Step 4: Run Database Schema

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy the entire content from `supabase_setup.sql` file
4. Paste it into the SQL editor
5. Click "Run" (bottom right)
6. Wait for execution to complete
7. Check for any errors - all commands should succeed

## Step 5: Enable Email Authentication

1. Go to **Authentication** > **Providers**
2. Find **Email** provider
3. Make sure it's **Enabled**
4. Configure email settings:
   - **Enable email confirmations**: Toggle OFF for testing (ON for production)
   - **Secure email change**: Toggle ON (recommended)
   - **Secure password change**: Toggle ON (recommended)

### Email Templates (Optional)
1. Go to **Authentication** > **Email Templates**
2. Customize templates for:
   - Confirm signup
   - Magic Link
   - Change Email Address
   - Reset Password

## Step 6: Configure Authentication Settings

1. Go to **Authentication** > **Configuration**
2. Set **Site URL**: Your app's URL or `http://localhost:3000` for testing
3. Add **Redirect URLs**:
   ```
   http://localhost:3000/**
   medinexus://callback
   ```

## Step 7: Setup Storage (for file uploads)

1. Go to **Storage**
2. Create buckets:
   - `avatars` - for profile pictures
     - Public bucket: YES
     - File size limit: 5MB
     - Allowed MIME types: image/jpeg, image/png, image/webp
   
   - `medical-records` - for patient documents
     - Public bucket: NO
     - File size limit: 10MB
     - Allowed MIME types: image/*, application/pdf
   
   - `prescriptions` - for prescription images
     - Public bucket: NO
     - File size limit: 5MB
     - Allowed MIME types: image/*, application/pdf

3. Set storage policies for each bucket (use SQL editor):

```sql
-- Avatar policies
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'avatars');

-- Medical records policies
CREATE POLICY "Patients can upload their own records"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'medical-records' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own medical records"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'medical-records' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## Step 8: Test the Setup

### Test Database Connection
1. In SQL Editor, run:
```sql
SELECT * FROM profiles LIMIT 1;
```
Should return empty result (table exists but no data)

### Test Authentication
1. Run your Flutter app
2. Try to sign up with a test account
3. Check Supabase **Authentication** > **Users** to see the new user

## Step 9: User Registration Flow

When a user signs up in the app:

1. **Supabase Auth creates user**
   - User entry in `auth.users` table
   - User ID (UUID) generated

2. **Profile is created automatically**
   - Trigger inserts into `profiles` table
   - Links to auth.users via ID

3. **Role-specific profile created**
   - If doctor: entry in `doctor_profiles`
   - If patient: entry in `patient_profiles`

## Step 10: Testing Authentication

### Create Test Patient Account
```dart
// In your Flutter app's sign up page
Email: patient@test.com
Password: Test123!
Name: Test Patient
Role: Patient
```

### Create Test Doctor Account
```dart
Email: doctor@test.com
Password: Test123!
Name: Dr. Test
Role: Doctor
Specialization: General Medicine
```

### Verify in Supabase
1. Go to **Authentication** > **Users**
2. You should see both test accounts
3. Go to **Table Editor** > **profiles**
4. You should see profile entries for both users
5. Check **doctor_profiles** and **patient_profiles** tables

## Common Issues & Solutions

### Issue: Email confirmation required
**Solution**: Go to Authentication > Providers > Email, disable "Enable email confirmations" for testing

### Issue: Invalid credentials error
**Solution**: Check that:
- Email is valid format
- Password is at least 6 characters
- User doesn't already exist

### Issue: Profile not created after signup
**Solution**: Check that:
- RLS policies are enabled
- User has permissions to insert into profiles table
- Check SQL logs for errors

### Issue: Can't see data in tables
**Solution**: 
- Check RLS policies are correctly set
- Verify user is authenticated
- Check logs in Supabase dashboard

## Security Best Practices

1. **Never expose your service_role key** - Only use anon/public key in client
2. **Enable RLS on all tables** - Already done in setup script
3. **Use HTTPS only** - Supabase does this by default
4. **Validate all user input** - Do this in your Flutter app
5. **Enable email confirmations in production** - Better security
6. **Use strong passwords** - Enforce in your app
7. **Regularly backup your database** - Use Supabase's backup features

## Production Checklist

Before deploying to production:

- [ ] Change database password to strong password
- [ ] Enable email confirmations
- [ ] Set up custom email templates
- [ ] Configure proper redirect URLs
- [ ] Set up database backups
- [ ] Enable 2FA for Supabase account
- [ ] Review and test all RLS policies
- [ ] Set up monitoring and alerts
- [ ] Configure rate limiting
- [ ] Review storage policies and limits

## Need Help?

- Supabase Documentation: https://supabase.com/docs
- Supabase Discord: https://discord.supabase.com
- Flutter Supabase Package: https://pub.dev/packages/supabase_flutter

## Database Schema Overview

### Core Tables:
- `profiles` - Base user profiles (linked to auth.users)
- `doctor_profiles` - Doctor-specific data
- `patient_profiles` - Patient-specific data
- `appointments` - Doctor-patient appointments
- `prescriptions` - Medical prescriptions
- `medications` - Prescription medications
- `lab_tests` - Lab test orders and results
- `medical_records` - Patient documents
- `doctor_reviews` - Doctor ratings and reviews
- `doctor_availability` - Doctor schedule
- `conversations` - Chat conversations
- `messages` - Chat messages
- `notifications` - User notifications

### All tables have:
- Automatic `created_at` timestamp
- Automatic `updated_at` timestamp (via trigger)
- Proper indexes for performance
- Row Level Security (RLS) policies
- Foreign key constraints

## Next Steps

After completing this setup:

1. Test authentication flow in your app
2. Create test appointments
3. Test prescription creation
4. Test chat functionality
5. Verify notifications are working
6. Test file uploads to storage
7. Check RLS policies work correctly
8. Test on both doctor and patient accounts

Your database is now ready for development! 🎉
