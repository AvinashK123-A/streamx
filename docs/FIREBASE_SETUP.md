# Firebase Setup Guide for StreamX

## Overview

StreamX uses Firebase for Analytics, Crashlytics, Performance Monitoring, Push Notifications, and Remote Config.

## Step 1: Create Firebase Projects

Create separate Firebase projects for each environment:

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create three projects:
   - `streamx-dev` — for development
   - `streamx-staging` — for staging
   - `streamx-prod` — for production

## Step 2: Register Your Apps

### Android App
1. Click "Add app" → Android
2. Package name: `com.streamx.app`
3. App nickname: `StreamX Android`
4. Download `google-services.json`
5. Place in `android/app/google-services.json`

### iOS App
1. Click "Add app" → iOS
2. Bundle ID: `com.streamx.app`
3. App nickname: `StreamX iOS`
4. Download `GoogleService-Info.plist`
5. Place in `ios/Runner/GoogleService-Info.plist`

### Web App
1. Click "Add app" → Web
2. App nickname: `StreamX Web`
3. Enable Firebase Hosting
4. Run: `flutterfire configure` to auto-generate `lib/core/config/firebase_options.dart`

## Step 3: Enable Firebase Services

### Authentication
1. Firebase Console → Authentication → Sign-in method
2. Enable: Email/Password, Google (optional)

### Firestore (optional for user data)
1. Firebase Console → Firestore Database
2. Create database in production mode
3. Set up security rules

### Analytics
1. Firebase Console → Analytics → Settings
2. Enable Google Analytics for the project
3. No code changes needed — auto-enabled

### Crashlytics
1. Firebase Console → Crashlytics
2. Follow setup wizard
3. Already integrated in code via `CrashlyticsService`

### Performance Monitoring
1. Firebase Console → Performance
2. Auto-enabled after SDK integration

### Cloud Messaging (FCM)
1. Firebase Console → Cloud Messaging
2. Note your **Server Key** for backend
3. Note your **Sender ID** → update `FCM_SENDER_ID` in .env files

#### iOS APNS Configuration
1. Apple Developer Console → Certificates → APNs Key
2. Download .p8 key file
3. Firebase Console → Project Settings → Cloud Messaging → APNs
4. Upload the .p8 key, enter Key ID and Team ID

### Remote Config
1. Firebase Console → Remote Config
2. Add parameters for feature flags:
   - `maintenance_mode` (bool: false)
   - `min_app_version` (string: "1.0.0")
   - `featured_video_id` (string)
   - `video_buffer_size_mb` (number: 15)

## Step 4: Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId;
    }
    
    // Videos are publicly readable
    match /videos/{videoId} {
      allow read: if true;
      allow write: if false; // Server-side only
    }
    
    // Watch history — user specific
    match /watch_history/{userId}/{videoId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId;
    }
  }
}
```

## Step 5: Firebase Hosting Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize hosting
firebase init hosting

# Configuration:
# - Project: streamx-prod
# - Public directory: build/web
# - Single page app: Yes
# - Overwrite index.html: No
# - Set up GitHub Actions: Yes (optional)
```

`firebase.json` is already configured in the repository root.

## Step 6: CI/CD Secrets

After setting up Firebase, add these secrets to GitHub:

```
GOOGLE_SERVICES_JSON          → base64(android/app/google-services.json)
GOOGLE_SERVICE_INFO_PLIST     → base64(ios/Runner/GoogleService-Info.plist)
FIREBASE_SERVICE_ACCOUNT_JSON → Firebase service account JSON (for hosting deploy)
PROD_FIREBASE_PROJECT_ID      → streamx-prod
PROD_FIREBASE_APP_ID_ANDROID  → From google-services.json
PROD_FIREBASE_APP_ID_IOS      → From GoogleService-Info.plist
PROD_FCM_SENDER_ID             → From Firebase project settings
PROD_FIREBASE_API_KEY         → From Firebase project settings
PROD_FIREBASE_STORAGE_BUCKET  → streamx-prod.appspot.com
PROD_FIREBASE_AUTH_DOMAIN     → streamx-prod.firebaseapp.com
PROD_FIREBASE_DATABASE_URL    → https://streamx-prod-default-rtdb.firebaseio.com
```

### Generate Service Account
1. Firebase Console → Project Settings → Service accounts
2. Click "Generate new private key"
3. Download JSON file
4. Add to GitHub Secrets as `FIREBASE_SERVICE_ACCOUNT_JSON`

### Encode Files for Secrets
```bash
# macOS
base64 -i android/app/google-services.json | pbcopy
base64 -i ios/Runner/GoogleService-Info.plist | pbcopy

# Linux
base64 android/app/google-services.json | xclip -selection clipboard
base64 ios/Runner/GoogleService-Info.plist | xclip -selection clipboard
```

## Verification

Test Firebase integration:
```bash
# Verify Android build with Firebase
flutter build apk --debug
# Check logcat for Firebase initialization messages

# Verify iOS build
flutter build ios --debug --no-codesign
# Check Xcode console for Firebase messages
```

## Troubleshooting

### "No Firebase app '[DEFAULT]' has been created"
- Ensure `Firebase.initializeApp()` is called in `main.dart` before `runApp()`
- Verify `google-services.json` / `GoogleService-Info.plist` is in the correct location

### Crashlytics not showing crashes
- Crashes only appear in the Firebase Console after 24 hours
- Use `FirebaseCrashlytics.instance.crash()` for a test crash in debug mode

### FCM not receiving messages
- Verify APNS certificate is configured (iOS)
- Check FCM token is being sent to your backend
- Verify notification channel is created (Android 8+)
