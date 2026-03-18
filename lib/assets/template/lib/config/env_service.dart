import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:{{project_name}}/config/flavor_config.dart';

enum EnvVariables { BASE_URL, WORKSPACE_ID }

class EnvService {
  Future init() async {
    try {
      await dotenv.load(fileName: FlavorConfig.instance.buildFlavor.envFile);
    } catch (e) {
      debugPrint("EnvService Init Error: $e");
    }
  }

  String get baseUrl => dotenv.get(EnvVariables.BASE_URL.name);
  String get workspaceId => dotenv.get(EnvVariables.WORKSPACE_ID.name);
}
