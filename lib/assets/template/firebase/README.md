# {{app_display_name}} - Firebase Configuration

This directory contains the Firebase service configuration files for the **{{project_name}}** project.

## 🚀 Environment Specific Configs

The following environments have been configured for Firebase:

<!-- @REPEAT_FLAVOR_START -->
### Flavor: {{flavor}}
- **Android Support**: [google-services.json] in `android/app/src/{{flavor}}/`
- **iOS Support**: [GoogleService-Info.plist] in `ios/Runner/`
<!-- @REPEAT_FLAVOR_END -->

## 🛠 Manual Configuration (if needed)

If you need to update any Firebase settings later, you can run:
```bash
flutterfire configure
```
This will regenerate the `lib/firebase_options.dart` file based on the selected Firebase Project.

---
Part of **{{project_name}}** ecosystem.
