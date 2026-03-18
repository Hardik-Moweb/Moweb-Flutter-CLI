import 'dart:convert';

import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:{{project_name}}/features/auth/models/profile_model.dart';
import 'package:{{project_name}}/features/auth/models/user_data_model.dart';
import 'package:{{project_name}}/utils/global_state.dart';
import 'package:{{project_name}}/utils/import.dart';

/// UserSessionManager handles saving and retrieving user session data
/// using both SharedPreferences for persistence and GlobalState for runtime access
class UserSessionManager {
  static final UserSessionManager _instance = UserSessionManager._internal();
  
  factory UserSessionManager() {
    return _instance;
  }
  
  UserSessionManager._internal();
  
  /// Save user data from login response to both SharedPreferences and GlobalState
  Future<void> saveLoginData(LoginResponseModel data,) async {
    // Save to SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = json.encode(data.toJson());
    printLog(jsonData);
    sharedPreferences.setBool(PreferenceKey.prefIsUserLoggedIn, true);
    sharedPreferences.setString(Pref.loginData, jsonData);

    if(data.data?.tokens != null) {
      sharedPreferences.setString(PreferenceKey.prefAccessToken, data.data?.tokens?.accessToken ?? '');
      sharedPreferences.setString(PreferenceKey.prefRefreshToken, data.data?.tokens?.refreshToken ?? '');
    }
    
    // Update GlobalState
    globalState.loginResponseData = data;
    
    // Update currency symbol from login response
    globalState.updateCurrency(data.data?.user?.currency);
    
    // Initialize or update combined user data
    if (globalState.userData == null) {
      globalState.userData = UserDataModel.fromLoginResponse(data);
    } else {
      globalState.userData = UserDataModel.fromLoginResponse(data);
    }
    
    // Save combined user data
    await saveCombinedUserData();
    globalState.updateIsSuperAdminFromUserData();
  }
  
  /// Save profile data from profile response to both SharedPreferences and GlobalState
  Future<void> saveProfileData(ProfileModel data) async {
    // Save to SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = json.encode(data.toJson());
    printLog(jsonData);
    sharedPreferences.setString(Pref.profileData, jsonData);
    
    // Update GlobalState
    globalState.profileData = data.data;
    
    // Update combined user data
    globalState.userData ??= UserDataModel();
    
    // Update combined data with profile information
    globalState.userData!.updateFromProfileResponse(data);
    
    // Save combined user data
    await saveCombinedUserData();
    globalState.updateIsSuperAdminFromUserData();
  }
  
  /// Save the combined user data to SharedPreferences
  Future<void> saveCombinedUserData() async {
    if (globalState.userData == null) return;
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = json.encode(globalState.userData!.toJson());
    sharedPreferences.setString(Pref.userData, jsonData);
  }
  
  /// Clear user data from both SharedPreferences and GlobalState
  Future<void> clearUserData() async {
    // Clear SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PreferenceKey.prefIsUserLoggedIn, false);
    sharedPreferences.setString(Pref.loginData, "");
    sharedPreferences.setString(Pref.profileData, "");
    sharedPreferences.setString(Pref.userData, "");
    sharedPreferences.setString(PreferenceKey.prefAccessToken, '');
    sharedPreferences.setString(PreferenceKey.prefRefreshToken, '');
    
    // Clear GlobalState
    globalState.clearUserData();
  }
  
  /// Load combined user data from SharedPreferences and update GlobalState
  Future<UserDataModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataString = sharedPreferences.getString(Pref.userData);
    
    if (userDataString == null || userDataString.isEmpty) {
      // If combined data doesn't exist, try to load individual data
      await loadLoginData();
      await loadProfileData();
      
      // Check if we have any data loaded
      if (globalState.userData != null) {
        return globalState.userData;
      }
      return null;
    }
    
    UserDataModel userData = UserDataModel.fromJson(json.decode(userDataString));
    
    // Update GlobalState
    globalState.userData = userData;
    globalState.updateIsSuperAdminFromUserData();
    
    return userData;
  }
  
  /// Load login data from SharedPreferences and update GlobalState
  Future<LoginResponseModel?> loadLoginData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? loginDataString = sharedPreferences.getString(Pref.loginData);
    
    if (loginDataString == null || loginDataString.isEmpty) {
      return null;
    }
    
    LoginResponseModel loginData = LoginResponseModel.fromJson(json.decode(loginDataString));
    
    // Update GlobalState
    globalState.loginResponseData = loginData;
    
    // Update currency symbol from login response
    globalState.updateCurrency(loginData.data?.user?.currency);
    
    // Initialize or update combined user data
    if (globalState.userData == null) {
      globalState.userData = UserDataModel.fromLoginResponse(loginData);
    } else {
      // Create a new combined user data from login response
      UserDataModel newData = UserDataModel.fromLoginResponse(loginData);
      
      // Preserve profile-specific fields
      if (globalState.userData!.employeeId != null) {
        newData.employeeId = globalState.userData!.employeeId;
      }
      if (globalState.userData!.lastLoginAt != null) {
        newData.lastLoginAt = globalState.userData!.lastLoginAt;
      }
      if (globalState.userData!.roleDetails != null) {
        newData.roleDetails = globalState.userData!.roleDetails;
      }
      if (globalState.userData!.roleName != null) {
        newData.roleName = globalState.userData!.roleName;
      }
      if (globalState.userData!.departmentName != null) {
        newData.departmentName = globalState.userData!.departmentName;
      }
      
      globalState.userData = newData;
    }
    globalState.updateIsSuperAdminFromUserData();
    
    return loginData;
  }
  
  /// Load profile data from SharedPreferences and update GlobalState
  Future<ProfileModel?> loadProfileData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? profileDataString = sharedPreferences.getString(Pref.profileData);
    
    if (profileDataString == null || profileDataString.isEmpty) {
      return null;
    }
    
    ProfileModel profileData = ProfileModel.fromJson(json.decode(profileDataString));
    
    // Update GlobalState
    globalState.profileData = profileData.data;
    
    // Update combined user data with profile information
    globalState.userData ??= UserDataModel();
    globalState.userData!.updateFromProfileResponse(profileData);
    globalState.updateIsSuperAdminFromUserData();
    
    return profileData;
  }
  
  /// Get access token from SharedPreferences
  Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(PreferenceKey.prefAccessToken);
    
    return token;
  }
  
  /// Get device ID from SharedPreferences
  Future<String?> getDeviceId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? deviceId = sharedPreferences.getString(PreferenceKey.prefIntUDID);
    
    // Update GlobalState
    if (deviceId != null) {
      globalState.strDeviceId = deviceId;
    }
    
    return deviceId;
  }
}

// Create a global instance for easy access throughout the app
final userSessionManager = UserSessionManager();