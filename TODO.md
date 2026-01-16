# Release Checklist

Manual steps remaining before app store release. See [BUILD.md](BUILD.md) for detailed build instructions.

## Build Setup

- [ ] Android: Create keystore and `key.properties` (see BUILD.md)
- [ ] iOS: Configure Xcode Cloud in App Store Connect

## GitHub Actions (Optional)

- [ ] Add Android signing secrets to GitHub
- [ ] Uncomment release build section in `.github/workflows/main.yaml`

## Pre-Submission Verification

- [ ] Run `flutter analyze` - no issues
- [ ] Run `flutter test` - all tests pass
- [ ] Build and test on real Android device
- [ ] Build and test on real iOS device
