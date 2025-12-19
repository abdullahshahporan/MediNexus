# MediNexus Lottie Animations Guide

This directory contains all the Lottie animation JSON files used in the MediNexus application for enhanced user experience and engaging interactions.

## Required Animations

### 1. Loading & Progress
- **`loading_dots.json`**
  - Description: General loading animation with three bouncing dots
  - Duration: 1-2 seconds (looping)
  - Style: Simple, medical theme colors
  - Usage: General loading states, API calls
  - Keywords: loading, dots, bounce, progress
  
- **`loading_heart.json`**
  - Description: Heart with pulse animation for medical context
  - Duration: 2 seconds (looping)
  - Style: Heart icon with ECG pulse effect
  - Usage: Health data loading, medical operations
  - Keywords: heart, pulse, medical, loading
  
- **`loading_spinner_medical.json`**
  - Description: Circular spinner with medical cross/stethoscope
  - Duration: 1.5 seconds (looping)
  - Style: Rotating medical symbol
  - Usage: Page transitions, data fetching
  - Keywords: spinner, medical, rotate, loading

### 2. Success States
- **`success_checkmark.json`**
  - Description: Animated checkmark in circle
  - Duration: 1.5 seconds (plays once)
  - Style: Smooth draw-in effect, green checkmark
  - Usage: Form submissions, successful operations
  - Keywords: success, checkmark, done, complete
  
- **`success_appointment.json`**
  - Description: Calendar with checkmark animation
  - Duration: 2 seconds (plays once)
  - Style: Calendar icon morphing to checkmark
  - Usage: Appointment booking confirmation
  - Keywords: appointment, calendar, success, booking
  
- **`payment_success.json`**
  - Description: Payment completed animation
  - Duration: 2.5 seconds (plays once)
  - Style: Coins, checkmark, celebratory effect
  - Usage: Payment confirmation screens
  - Keywords: payment, money, success, transaction

### 3. Error States
- **`error_alert.json`**
  - Description: Error icon with shake animation
  - Duration: 1.5 seconds (plays once)
  - Style: Red error icon with attention effect
  - Usage: Form errors, failed operations
  - Keywords: error, alert, warning, fail
  
- **`error_connection.json`**
  - Description: No internet/connection error
  - Duration: 2 seconds (plays once)
  - Style: Broken wifi/signal animation
  - Usage: Network error states
  - Keywords: error, network, connection, offline
  
- **`error_not_found.json`**
  - Description: 404/not found animation
  - Duration: 2 seconds (plays once)
  - Style: Magnifying glass with X or empty search
  - Usage: Empty search results, 404 pages
  - Keywords: error, not found, 404, search

### 4. Onboarding
- **`onboarding_doctor.json`**
  - Description: Doctor with stethoscope animation
  - Duration: 3-4 seconds (looping)
  - Style: Friendly doctor character, subtle movements
  - Usage: Doctor onboarding screen
  - Keywords: doctor, medical, professional, onboarding
  
- **`onboarding_health.json`**
  - Description: Health tracking/wellness animation
  - Duration: 3-4 seconds (looping)
  - Style: Heart, vitals, health icons floating
  - Usage: Health features onboarding
  - Keywords: health, wellness, tracking, vitals
  
- **`onboarding_ai.json`**
  - Description: AI assistant/robot animation
  - Duration: 3-4 seconds (looping)
  - Style: Friendly AI robot with medical symbols
  - Usage: AI symptom checker introduction
  - Keywords: AI, robot, assistant, medical

### 5. Empty States
- **`empty_appointments.json`**
  - Description: Empty calendar animation
  - Duration: 2-3 seconds (looping)
  - Style: Calendar with pages flipping, empty state
  - Usage: No appointments screen
  - Keywords: empty, calendar, appointments, none
  
- **`empty_messages.json`**
  - Description: Empty mailbox/inbox animation
  - Duration: 2-3 seconds (looping)
  - Style: Empty envelope or mailbox
  - Usage: No messages screen
  - Keywords: empty, messages, chat, inbox
  
- **`empty_medical_records.json`**
  - Description: Empty folder animation
  - Duration: 2-3 seconds (looping)
  - Style: Open empty folder with pages
  - Usage: No medical records screen
  - Keywords: empty, records, documents, folder
  
- **`empty_search.json`**
  - Description: No search results animation
  - Duration: 2-3 seconds (looping)
  - Style: Magnifying glass with question mark
  - Usage: Empty search results
  - Keywords: empty, search, not found, results

### 6. Health & Medical
- **`heart_beat.json`**
  - Description: Beating heart with pulse lines
  - Duration: 2 seconds (looping)
  - Style: Realistic heart beat animation with ECG
  - Usage: Health monitoring, vitals display
  - Keywords: heart, pulse, beat, ecg, vital
  
- **`medicine_pills.json`**
  - Description: Pills/medication animation
  - Duration: 2-3 seconds (looping)
  - Style: Pills bouncing or rotating
  - Usage: Prescription screens, medication reminders
  - Keywords: pills, medicine, medication, prescription
  
- **`doctor_consultation.json`**
  - Description: Doctor-patient consultation animation
  - Duration: 3-4 seconds (looping)
  - Style: Two characters in consultation scene
  - Usage: Consultation booking, appointment screens
  - Keywords: doctor, patient, consultation, appointment
  
- **`medical_report.json`**
  - Description: Medical report/document animation
  - Duration: 2-3 seconds (plays once)
  - Style: Document with medical cross generating
  - Usage: Report generation, prescription creation
  - Keywords: report, document, medical, prescription

### 7. Actions & Interactions
- **`search_doctor.json`**
  - Description: Magnifying glass searching animation
  - Duration: 2 seconds (looping)
  - Style: Magnifying glass moving, searching effect
  - Usage: Doctor search functionality
  - Keywords: search, find, magnifying glass, doctor
  
- **`location_pin.json`**
  - Description: Map pin dropping animation
  - Duration: 1.5 seconds (plays once)
  - Style: Location pin dropping and bouncing
  - Usage: Location selection, find nearby doctors
  - Keywords: location, map, pin, nearby
  
- **`video_call.json`**
  - Description: Video call connecting animation
  - Duration: 2-3 seconds (looping)
  - Style: Video camera with signal waves
  - Usage: Telemedicine, video consultation
  - Keywords: video, call, telemedicine, consultation
  
- **`notification_bell.json`**
  - Description: Bell ringing animation
  - Duration: 1.5 seconds (plays once)
  - Style: Bell with ring lines, bouncing
  - Usage: New notifications indicator
  - Keywords: notification, bell, alert, reminder

### 8. Splash & Intro
- **`splash_logo.json`**
  - Description: App logo reveal animation
  - Duration: 2-3 seconds (plays once)
  - Style: Logo builds up, fades in, or morphs
  - Usage: App splash screen
  - Keywords: splash, logo, intro, reveal
  
- **`welcome_wave.json`**
  - Description: Welcoming hand wave animation
  - Duration: 2 seconds (plays once)
  - Style: Hand waving friendly gesture
  - Usage: Welcome screens, first-time user
  - Keywords: welcome, hello, wave, greeting

## Animation Specifications

### File Format:
- **Format**: JSON (Lottie format)
- **Version**: Bodymovin 5.7.0 or higher
- **Compression**: Minified JSON

### Size Guidelines:
- **Maximum File Size**: 200KB per animation
- **Target Size**: 50-100KB for optimal performance
- **Dimensions**: 500x500px (will scale responsively)

### Performance Guidelines:
- **Duration**: 1-4 seconds (avoid very long animations)
- **Frame Rate**: 30fps or 60fps
- **Layers**: Minimize layer count (<50 layers)
- **Complexity**: Keep animations simple for smooth playback

### Style Guidelines:
- **Colors**: Use app theme colors or provide customizable color properties
- **Style**: Modern, clean, minimalist
- **Mood**: Friendly, professional, reassuring (medical context)
- **Accessibility**: Avoid rapid flashing (seizure risk)

## Sources for Lottie Animations

### Free Lottie Resources:
1. **LottieFiles** - https://lottiefiles.com/
   - Largest library, free and premium
   - Search keywords: medical, health, doctor, patient
   
2. **IconScout Lottie** - https://iconscout.com/lottie
   - High-quality medical animations
   - Free and premium options
   
3. **LordIcon** - https://lordicon.com/
   - Animated icons, many free
   - Good for micro-interactions
   
4. **Rive** - https://rive.app/community
   - Alternative animation format
   - Can export to Lottie

### Creating Custom Animations:
1. **After Effects + Bodymovin**
   - Industry standard
   - Export to Lottie JSON
   
2. **Figma + Lottie Plugin**
   - Design in Figma
   - Export via plugin
   
3. **Rive** - Create and export
   - Modern animation tool
   - Web-based editor

## Search Keywords for Medical Animations
When searching on LottieFiles or other platforms, use these keywords:
- medical, healthcare, doctor, patient
- stethoscope, heart, pulse, ECG
- pills, medication, prescription
- hospital, clinic, ambulance
- appointment, calendar, schedule
- health, wellness, fitness
- AI, assistant, chatbot
- success, error, loading
- telemedicine, video call
- search, location, notification

## Implementation Example

### Using Lottie in Flutter:
```dart
import 'package:lottie/lottie.dart';

// Basic usage
Lottie.asset(
  'assets/lottie/loading_heart.json',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)

// With controller
AnimationController _controller;
Lottie.asset(
  'assets/lottie/success_checkmark.json',
  controller: _controller,
  onLoaded: (composition) {
    _controller
      ..duration = composition.duration
      ..forward();
  },
)

// With repeat
Lottie.asset(
  'assets/lottie/loading_dots.json',
  repeat: true,
)
```

## Optimization Tips

### Before Adding:
1. Preview on LottieFiles to check quality
2. Check file size (<200KB target)
3. Test on multiple devices
4. Ensure smooth 60fps playback

### Optimization Tools:
- **Lottie Web Player** - Test in browser
- **LottieFiles Optimizer** - Compress JSON
- **Bodymovin** - Export settings in After Effects

## Current Status
⏳ = Needed | ✅ = Exists | 📝 = Using alternative

- ⏳ All animations listed above need to be added
- 📝 Currently using static icons/images as placeholders
- ✅ App will function without animations but UX will be greatly enhanced

## Priority Animations (Add First)
1. loading_dots.json
2. loading_heart.json
3. success_checkmark.json
4. error_alert.json
5. splash_logo.json
6. empty_appointments.json
7. heart_beat.json
8. doctor_consultation.json

## Testing Checklist
Before adding any animation:
- [ ] File size <200KB
- [ ] Plays smoothly on low-end devices
- [ ] Colors match app theme
- [ ] Duration is appropriate (not too long)
- [ ] Loops correctly if repeating
- [ ] No performance issues
- [ ] Looks good on both light and dark themes

## Notes
- All animations should work on both iOS and Android
- Test animations on real devices, not just emulators
- Consider providing 2x quality versions for high-end devices
- Maintain consistent animation style across the app
- Keep source After Effects/Figma files for future edits
- Document any special color properties for theming
