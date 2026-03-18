import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:{{project_name}}/features/auth/models/profile_model.dart';

/// Combined user model that merges data from both login and profile responses
class UserDataModel {
  // Basic user information
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImage;
  int? companyId;
  int? roleId;
  
  // Login specific fields
  String? accessToken;
  String? refreshToken;
  String? countryCode;
  String? currency;
  PermissionModel? permissions;
  Company? company;
  Company? role;
  
  // Profile specific fields
  String? createdAt;
  String? updatedAt;
  int? employeeId;
  String? lastLoginAt;
  String? slug;
  Role? roleDetails;
  String? roleName;
  String? departmentName;
  
  UserDataModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.profileImage,
    this.companyId,
    this.roleId,
    this.accessToken,
    this.refreshToken,
    this.countryCode,
    this.currency,
    this.permissions,
    this.company,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.employeeId,
    this.lastLoginAt,
    this.slug,
    this.roleDetails,
    this.roleName,
    this.departmentName,
  });
  
  /// Create from login response
  UserDataModel.fromLoginResponse(LoginResponseModel loginModel) {
    if (loginModel.data?.user != null) {
      final user = loginModel.data!.user!;
      
      // Basic user information
      id = user.id;
      firstName = user.firstName;
      lastName = user.lastName;
      email = user.email;
      phone = user.phone;
      profileImage = user.profileImage;
      companyId = user.companyId;
      roleId = user.roleId;
      
      // Login specific fields
      countryCode = user.countryCode.toString();
      currency = user.currency;
      // permissions = user.permissions;
      company = user.company;
      role = user.role;
      
      // Token information
      if (loginModel.data?.tokens != null) {
        accessToken = loginModel.data?.tokens?.accessToken;
        refreshToken = loginModel.data?.tokens?.refreshToken;
      }
    }
  }
  
  /// Update from profile response
  void updateFromProfileResponse(ProfileModel profileModel) {
    if (profileModel.data != null) {
      final profile = profileModel.data!;
      
      // Update basic user information
      id = profile.id ?? id;
      firstName = profile.firstName ?? firstName;
      lastName = profile.lastName ?? lastName;
      email = profile.email ?? email;
      phone = profile.phone ?? phone;
      profileImage = profile.profileImage ?? profileImage;
      companyId = profile.companyId ?? companyId;
      
      // Update profile specific fields
      createdAt = profile.createdAt;
      updatedAt = profile.updatedAt;
      employeeId = profile.employeeId;
      lastLoginAt = profile.lastLoginAt;
      slug = profile.slug;
      roleDetails = profile.role;
      roleName = profile.roleName;
      departmentName = profile.departmentName;
    }
  }
  
  /// Create from JSON
  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    companyId = json['companyId'];
    roleId = json['roleId'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    countryCode = json['countryCode'];
    currency = json['currency'];
    permissions = json['permissions'] != null ? PermissionModel.fromJson(json['permissions']) : null;
    company = json['company'] != null ? Company.fromJson(json['company']) : null;
    role = json['role'] != null ? Company.fromJson(json['role']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    employeeId = json['employeeId'];
    lastLoginAt = json['lastLoginAt'];
    slug = json['slug'];
    roleDetails = json['roleDetails'] != null ? Role.fromJson(json['roleDetails']) : null;
    roleName = json['roleName'];
    departmentName = json['departmentName'];
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['profileImage'] = profileImage;
    data['companyId'] = companyId;
    data['roleId'] = roleId;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['countryCode'] = countryCode;
    data['currency'] = currency;
    if (permissions != null) {
      data['permissions'] = permissions!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['employeeId'] = employeeId;
    data['lastLoginAt'] = lastLoginAt;
    data['slug'] = slug;
    if (roleDetails != null) {
      data['roleDetails'] = roleDetails!.toJson();
    }
    data['roleName'] = roleName;
    data['departmentName'] = departmentName;
    return data;
  }
}