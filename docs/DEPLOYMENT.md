# StreamX Deployment Guide

## Overview

This document covers complete deployment procedures for StreamX across all platforms.

## Prerequisites

- Flutter SDK (>=3.19.0)
- Dart SDK (>=3.3.0)
- Java 17 (for Android builds)
- Xcode 15.2+ (for iOS builds, macOS only)
- Firebase CLI
- Android Studio / VS Code
- CocoaPods (for iOS)

## Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/AvinashK123-A/streamx.git
cd streamx
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Firebase Configuration

#### Android
1. Go to Firebase Console → Project Settings → Android
2. Download `google-services.json`
3. Place it in `android/app/google-services.json`

#### iOS
1. Go to Firebase Console → Project Settings → iOS
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`

#### Web
1. Run `flutterfire configure` to auto-generate `lib/core/config/firebase_options.dart`
   OR manually update the placeholder values in that file.

### 3. Environment Configuration

Copy the appropriate env file:
```bash
# Development
cp .env.dev .env

# Staging
cp .env.staging .env

# Production
cp .env.prod .env
```

Fill in all environment variables marked as `${VAR_NAME}`.

---

## Android Deployment

### Debug Build
```bash
flutter run --debug
```

### Release APK (for distribution)
```bash
flutter build apk --release \
  --dart-define-from-file=.env \
  --obfuscate \
  --split-debug-info=build/debug-symbols
```

### Release APK (split by ABI — smaller size)
```bash
flutter build apk --release \
  --split-per-abi \
  --dart-define-from-file=.env
```

### Release App Bundle (Google Play)
```bash
flutter build appbundle --release \
  --dart-define-from-file=.env \
  --obfuscate \
  --split-debug-info=build/debug-symbols
```

### App Signing Setup

1. Generate keystore:
```bash
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias streamx
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=streamx
storeFile=keystore.jks
```

3. Build signed APK/AAB — signing is automatic when `key.properties` exists.

### Google Play Store Upload

1. Build AAB: `flutter build appbundle --release`
2. Go to Google Play Console
3. Create new release
4. Upload `build/app/outputs/bundle/release/app-release.aab`

---

## iOS Deployment

### Prerequisites
- macOS with Xcode 15.2+
- Apple Developer Account
- Provisioning profiles configured

### Setup
```bash
cd ios
pod install --repo-update
```

### Debug Run
```bash
flutter run --debug
```

### Release Build (IPA)
```bash
flutter build ipa --release \
  --dart-define-from-file=.env \
  --export-options-plist=ios/ExportOptions.plist
```

### TestFlight Upload
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/streamx.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

### App Store Connect
1. Build IPA
2. Open Xcode → Organizer
3. Distribute App → App Store Connect
4. Follow upload wizard

---

## Web Deployment

### Build
```bash
flutter build web --release \
  --dart-define-from-file=.env \
  --web-renderer canvaskit \
  --pwa-strategy offline-first \
  --tree-shake-icons
```

### Firebase Hosting

#### Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

#### Initialize (first time)
```bash
firebase init hosting
# Select project: streamx-prod
# Public directory: build/web
# Single page app: Yes
# Overwrite index.html: No
```

#### Deploy
```bash
firebase deploy --only hosting
```

#### Preview Channel (PRs/staging)
```bash
firebase hosting:channel:deploy preview-branch --expires 7d
```

---

## CI/CD Pipeline

### Workflows

| Workflow | Trigger | Output |
|---------|---------|--------|
| `ci-cd.yml` | All PRs + pushes | Analyze, Test, Build APK |
| `android_release.yml` | main/release branches + tags | Signed APK + AAB |
| `ios_release.yml` | main/release branches + tags | Signed IPA |
| `web_deploy.yml` | main/PRs/tags | Firebase Hosting deploy |

### Required GitHub Secrets

#### Android
- `ANDROID_KEYSTORE_BASE64` — base64 encoded keystore.jks
- `ANDROID_STORE_PASSWORD` — keystore password
- `ANDROID_KEY_PASSWORD` — key password
- `ANDROID_KEY_ALIAS` — key alias
- `GOOGLE_SERVICES_JSON` — base64 encoded google-services.json

#### iOS
- `IOS_DISTRIBUTION_CERT_BASE64` — base64 encoded .p12 certificate
- `IOS_DISTRIBUTION_CERT_PASSWORD` — certificate password
- `APPSTORE_ISSUER_ID` — App Store Connect issuer ID
- `APPSTORE_API_KEY_ID` — App Store Connect API key ID
- `APPSTORE_API_PRIVATE_KEY` — App Store Connect API private key
- `GOOGLE_SERVICE_INFO_PLIST` — base64 encoded GoogleService-Info.plist

#### Firebase
- `FIREBASE_SERVICE_ACCOUNT_JSON` — Firebase service account JSON
- `PROD_FIREBASE_PROJECT_ID` — Firebase project ID
- `PROD_API_KEY` — Production API key
- All other `PROD_*` variables from .env.prod

### Encode Secrets for GitHub

```bash
# Encode keystore
base64 -i android/app/keystore.jks | pbcopy

# Encode google-services.json
base64 -i android/app/google-services.json | pbcopy

# Encode GoogleService-Info.plist
base64 -i ios/Runner/GoogleService-Info.plist | pbcopy
```

---

## Health Checks

### Verify Android Build
```bash
flutter analyze
flutter test
flutter build apk --debug
```

### Verify iOS Build
```bash
flutter analyze
flutter test
flutter build ios --debug --no-codesign
```

### Verify Web Build
```bash
flutter analyze
flutter test
flutter build web --debug
```

---

## Performance Checklist

Before each release:

- [ ] Run `flutter analyze` — 0 errors
- [ ] Run `flutter test` — all tests passing
- [ ] Run `flutter test --coverage` — coverage >= 80%
- [ ] Profile with Flutter DevTools — no jank
- [ ] Test on low-end device (Android Go)
- [ ] Test on iPhone SE (smallest screen)
- [ ] Test offline functionality
- [ ] Test PiP mode (Android 8+, iOS 15+)
- [ ] Verify deep links work
- [ ] Verify push notifications work
- [ ] Check app startup time < 2s
- [ ] Verify memory usage < 250MB during video playback

---

## Rollback Procedure

### Android
- Google Play Console → Release Management → Re-activate previous release

### iOS
- App Store Connect — submit previous build for review

### Web (Firebase Hosting)
```bash
# List previous versions
firebase hosting:releases:list

# Rollback to specific version
firebase hosting:rollback --version VERSION_ID
```
