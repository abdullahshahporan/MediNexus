# MediNexus

MediNexus is a Flutter-based healthcare app concept with **role-based access** (Patient / Doctor), a modern glassmorphism UI, and an onboarding flow that routes users to the correct dashboard after authentication.

> Built with Flutter (Android/iOS ready) and structured for scalable feature development.

---

## Features

- **Role-based flow**
  - Select role (Patient / Doctor)
  - Route to the correct dashboard after sign-in
- **Animated splash screen**
  - Logo animation + timed transition
- **Patient dashboard**
  - Tab-based navigation: **Home**, **Appointments**, **Health Track**, **Profile**
- **Authentication**
  - Email/password sign-in (Supabase-ready)
- **Localization toggle**
  - Language switch UI (EN + extensible)
- **Modern UI**
  - Glass effect cards, polished navigation bar, dark theme-friendly design

---

## Tech Stack

- **Flutter / Dart**
- **State Management:** Provider
- **Backend/Auth:** Supabase (recommended)
- **Android:** Gradle (JDK 17 compatible)

---

## Project Structure (high level)

```text
lib/
  core/                 # theme, colors, utilities
  pages/
    patient/
      patient_dashboard_page.dart
      tabs/
        home_tab.dart
        appointments_tab.dart
        health_track_tab.dart
        profile_tab.dart
  providers/             # auth + language providers
  splash_screen.dart     # animated splash screen
```

---

## Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- **JDK 17** (required for modern Android Gradle Plugin)
- A Supabase project (if using Supabase auth)

### Install & Run
```bash
flutter pub get
flutter run
```

### Build APK (Release)
```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK output:
```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Supabase Configuration

If you use Supabase for authentication:
1. Create a Supabase project
2. Get:
   - **Project URL**
   - **Anon public key**
3. Add them to your app configuration (commonly via one of these patterns):
   - `--dart-define` values
   - `.env` file (with flutter_dotenv)
   - a constants/config file in `lib/`

> If you tell me where your Supabase URL/key are stored in this repo, I can tailor this section exactly to your structure.

---

## Android Notes (Important)

### Internet on Physical Devices
If sign-in works on emulator but fails on a real phone, ensure **INTERNET permission** exists in:

`android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## Screenshots

Add screenshots to `assets/` (or a `docs/` folder) and link them here:

- Splash
- Role selection
- Sign in
- Patient dashboard (Home / Appointments / Health / Profile)

Example:
```md
![Patient Dashboard](docs/screenshots/patient_dashboard.png)
```

---

## Roadmap (suggested)

- Doctor dashboard + patient management
- Appointment booking flow (search doctors, slots, payments)
- Health tracking (metrics, reminders, export)
- Push notifications (reminders, appointment updates)
- Unit + widget tests and CI

---

## Contributing

Contributions are welcome:
1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request

---

## License

Add a license (MIT/Apache-2.0/etc). Example:
- MIT License

---

## Author

**Asif Jawad**

**Abdullah Md. Shahporan**
