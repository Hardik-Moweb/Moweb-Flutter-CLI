# {{app_display_name}}

A premium Flutter application generated with CompanyAppCLI.

## 🚀 Getting Started

To get started with this project, ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Built-in Codegen (if any)**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 🛠 Tech Stack

- **Core**: Flutter & Dart
- **State Management**: Bloc / Provider (as per template)
- **Networking**: Dio
- **Storage**: Hive / Shared Preferences
- **Firebase Integration**: Enabled (optional)

## 🎨 Flavors & Environments

This project supports multiple flavors for different environments. Below is the list of configured flavors:

| Flavor | Run Command | Build APK | Build IPA |
|:-------|:------------|:----------|:----------|
<!-- @REPEAT_FLAVOR_START -->
| **{{flavor}}** | `flutter run --flavor {{flavor}}` | `flutter build apk --flavor {{flavor}}` | `flutter build ipa --flavor {{flavor}}` |
<!-- @REPEAT_FLAVOR_END -->

## 📦 Building for Release

### Android
To build a release APK for a specific flavor:
```bash
flutter build apk --release --flavor <flavor_name>
```

### iOS
To build a release IPA for a specific flavor:
```bash
flutter build ipa --release --flavor <flavor_name>
```
