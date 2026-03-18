
import 'dart:convert';

import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  AppPreference._privateConstructor();

  static final AppPreference instance = AppPreference._privateConstructor();

  // final String _fcmToken = "fcm-token";

  /*
  Future<void> saveFCMToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_fcmToken, token);
    return;
  }
  */

  /*
  Future<String> getFCMToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_fcmToken) ?? "";
  }
  */


  Future savePref(String data, String prefName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefName, data);
  }

  Future<String> getPref(String prefName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(prefName) ?? "";
    return languageCode;
  }

  /// Save report permissions list
  Future<void> saveReportPermissions(List<Reports> permissionsReports) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert list to JSON string
    List<Map<String, dynamic>> permissionsJson =
    permissionsReports.map((permission) => permission.toJson()).toList();
    String jsonString = json.encode(permissionsJson);
    await prefs.setString('reportPermissions', jsonString);
  }

  /// Get report permissions list
  Future<List<Reports>> getReportPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('reportPermissions');
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    
    try {
      List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => Reports.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Check if a specific permission key exists in report permissions
  Future<bool> hasReportPermission(String permissionKey) async {
    List<Reports> permissions = await getReportPermissions();
    return permissions.any((permission) => 
        permission.permissionKey == permissionKey);
  }

  /// Save user permissions (flat list of permission keys)
  /// Used by PermissionHelper for global permission management
  void setPermissions(List<String> permissions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userPermissions', permissions);
  }

  /// Get user permissions (flat list of permission keys)
  /// Used by PermissionHelper for global permission management
  Future<List<String>?> getPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userPermissions');
  }

  /// Clear user permissions
  void clearPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPermissions');
  }
}

