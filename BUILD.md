# Build & Release Guide

This document covers building release versions of Timeshare for Android and iOS.

## Development Builds

```bash
# Run on connected device/emulator
flutter run

# Build debug APK
flutter build apk --debug

# Build debug iOS (simulator)
flutter build ios --simulator
```

## Android Release Build

### 1. Create Keystore (One-time Setup)

Generate a new upload keystore for Google Play:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

You'll be prompted for:
- Keystore password
- Key password
- Your name, organization, etc.

**Important:** Store this keystore file and passwords securely. If lost, you cannot update your app on Play Store.

### 2. Create key.properties

Create `android/key.properties` (this file is gitignored):

```properties
storeFile=/path/to/upload-keystore.jks
storePassword=your_keystore_password
keyAlias=upload
keyPassword=your_key_password
```

### 3. Build Release APK/Bundle

```bash
# Build release APK
flutter build apk --release

# Build App Bundle (required for Play Store)
flutter build appbundle --release
```

Output locations:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## iOS Release Build

### 1. Configure Signing in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner project
3. Go to "Signing & Capabilities" tab
4. Select your Team (requires Apple Developer account)
5. Ensure "Automatically manage signing" is checked

### 2. Build Archive

```bash
# Build for release
flutter build ipa --release

# Or with export options
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

Output: `build/ios/ipa/timeshare.ipa`

### 3. Upload to App Store Connect

Using Xcode:
1. Open Xcode > Window > Organizer
2. Select the archive
3. Click "Distribute App"
4. Follow the upload wizard

Or using command line:
```bash
xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios \
  -u "your@apple.id" -p "@keychain:AC_PASSWORD"
```

## Web Deployment

To build and deploy the web app to the squishygoose server:

```bash
./scripts/deploy-web.sh
```

This script:
1. Builds the web release (`flutter build web --release --dart-define=ENV=prod`)
2. Copies files to `../squishygoose/timeshare-web/`

**Required directory structure:**
```
parent/
  timeshare/       <- this repo
  squishygoose/    <- deployment target (sibling directory)
```

## CI (Continuous Integration)

### GitHub Actions

The workflow at `.github/workflows/main.yaml` runs CI checks only (no deployment):

1. **Analyze**: `flutter analyze`
2. **Test**: `flutter test`
3. **Build**: `flutter build web --release`

The web build artifact is uploaded for download. **Deployment is manual.**

Android and iOS builds are done locally or via platform-specific CI (Xcode Cloud).

### Xcode Cloud (iOS)

iOS builds are handled by Xcode Cloud. Configure in App Store Connect:
1. Go to App Store Connect > Your App > Xcode Cloud
2. Create a new workflow
3. Configure build triggers (e.g., on push to main)
4. Xcode Cloud handles signing automatically with your App Store Connect credentials

## Troubleshooting

### Android: "key.properties not found"

The build will work but won't be signed. Create the file as described above.

### iOS: "No signing certificate"

1. Ensure you're signed into Xcode with your Apple ID
2. Your Apple Developer membership must be active
3. Try: Xcode > Preferences > Accounts > Download Manual Profiles

### ProGuard issues

If release builds crash but debug works, check `android/app/proguard-rules.pro` for missing keep rules.

### Build too large

- Android: Minification is enabled (`isMinifyEnabled = true`)
- Consider using `flutter build apk --split-per-abi` for smaller APKs
