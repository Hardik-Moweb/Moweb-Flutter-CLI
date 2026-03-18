import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name}}/utils/constants/strings.dart';

enum BuildFlavors {
// @REPEAT_FLAVOR_START
  {{flavor}},
// @REPEAT_FLAVOR_END
}

extension BuildFlavorsHelpers on BuildFlavors {
  String get key => name;
  String get appName => MyStrings.appName;

  String get title {
    switch (this) {
// @REPEAT_FLAVOR_START
      case BuildFlavors.{{flavor}}:
        return "{{app_display_name}} ({{flavor}})";
// @REPEAT_FLAVOR_END
    }
  }

  String get envFile {
    switch (this) {
// @REPEAT_FLAVOR_START
      case BuildFlavors.{{flavor}}:
        return "env/{{flavor}}.env";
// @REPEAT_FLAVOR_END
    }
  }
}

class FlavorConfig {
  final String appTitle;
  final BuildFlavors buildFlavor;

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance!;
  }

  FlavorConfig._internal({required this.appTitle, required this.buildFlavor});

  static Future<void> initFromNative() async {
    const platform = MethodChannel('{{ios_bundle}}/flavor');
    String? flavor;

    try {
      flavor = await platform.invokeMethod<String>('getFlavor');
      debugPrint("Native Flavor: $flavor");
    } catch (e) {
      debugPrint("Failed to get flavor from native: $e");
      flavor = "prod";
    }

    BuildFlavors buildFlavor;
    switch (flavor) {
// @REPEAT_FLAVOR_START
      case '{{flavor}}':
        buildFlavor = BuildFlavors.{{flavor}};
        break;
// @REPEAT_FLAVOR_END
      default:
        buildFlavor = BuildFlavors.values.first;
        break;
    }

    _instance = FlavorConfig._internal(
      appTitle: buildFlavor.title,
      buildFlavor: buildFlavor,
    );
  }
}
