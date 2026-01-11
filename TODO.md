# Release Checklist

Manual steps remaining before app store release.

## Firebase Console Configuration

After changing bundle IDs to `com.fitzsimmons.timeshare`, you need to update Firebase:

- [ ] Go to [Firebase Console](https://console.firebase.google.com/) → Project Settings → Your Apps
- [ ] Register new iOS app with bundle ID `com.fitzsimmons.timeshare`
- [ ] Register new Android app with package name `com.fitzsimmons.timeshare`
- [ ] Download new `GoogleService-Info.plist` → replace in `ios/Runner/`
- [ ] Download new `google-services.json` → replace in `android/app/`
- [ ] Update `lib/firebase_options.dart` with new configuration values from Firebase

## Android Release Build Setup

- [ ] Create upload keystore:
  ```bash
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
    -keysize 2048 -validity 10000 -alias upload
  ```
- [ ] Create `android/key.properties` (gitignored):
  ```properties
  storeFile=/path/to/upload-keystore.jks
  storePassword=your_keystore_password
  keyAlias=upload
  keyPassword=your_key_password
  ```
- [ ] Store keystore and passwords securely (cannot update app if lost)

## iOS Release Build Setup

- [ ] Configure Xcode Cloud in App Store Connect
- [ ] Verify signing works: `flutter build ipa --release`

## GitHub Actions (Optional - for signed CI builds)

- [ ] Add `ANDROID_KEYSTORE_BASE64` secret (base64-encoded keystore)
- [ ] Add `ANDROID_KEYSTORE_PASSWORD` secret
- [ ] Add `ANDROID_KEY_ALIAS` secret
- [ ] Add `ANDROID_KEY_PASSWORD` secret
- [ ] Uncomment release build section in `.github/workflows/main.yaml`

## Pre-Submission Verification

- [ ] Run `flutter analyze` - should show no issues
- [ ] Run `flutter test` - all 203 tests should pass
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build release AAB: `flutter build appbundle --release`
- [ ] Test on real Android device
- [ ] Test on real iOS device
