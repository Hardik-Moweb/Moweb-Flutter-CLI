class LoginResponseModel {
  bool? success;
  int? code;
  String? message;
  LoginData? data;

  LoginResponseModel({this.success, this.code, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    json['code'] = code;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class LoginData {
  User? user;
  Tokens? tokens;

  LoginData({this.user, this.tokens});

  LoginData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tokens = json['tokens'] != null
        ? Tokens.fromJson(json['tokens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImage;
  int? companyId;
  int? roleId;
  Company? company;
  Company? role;
  Object? countryCode;
  String? currency;
  PermissionModel? permissions;
  String? slug;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.profileImage,
    this.companyId,
    this.roleId,
    this.company,
    this.role,
    this.countryCode,
    this.currency,
    this.permissions,
    this.slug,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    companyId = json['company_id'];
    roleId = json['role_id'];
    company = json['company'] != null
        ? Company.fromJson(json['company'])
        : null;
    role = json['role'] != null ? Company.fromJson(json['role']) : null;
    countryCode = json['country_code'];
    currency = json['currency'];
    permissions = json['permissions'] != null
        ? PermissionModel.fromJson(json['permissions'])
        : null;
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_image'] = profileImage;
    data['company_id'] = companyId;
    data['role_id'] = roleId;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['country_code'] = countryCode;
    data['currency'] = currency;
    if (permissions != null) {
      data['permissions'] = permissions!.toJson();
    }
    data['slug'] = slug;
    return data;
  }
}

class Company {
  int? id;
  String? name;

  Company({this.id, this.name});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class PermissionModel {
  PermissionData? permissionData;

  PermissionModel({this.permissionData});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    permissionData = json['data'] != null
        ? PermissionData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (permissionData != null) {
      data['data'] = permissionData!.toJson();
    }
    return data;
  }
}

class PermissionData {
  List<Reports>? activityTypes;
  List<Reports>? clients;
  List<Reports>? companySettings;
  List<Reports>? consultants;
  List<Reports>? contractors;
  List<Reports>? cost;
  List<Reports>? dashboard;
  List<Reports>? departments;
  List<Reports>? email;
  List<Reports>? employees;
  List<Reports>? leaves;
  List<Reports>? leaveTypes;
  List<Reports>? payroll;
  List<Reports>? permissions;
  List<Reports>? projects;
  List<Reports>? reports;
  List<Reports>? roles;
  List<Reports>? salarySettings;
  List<Reports>? timeTracking;
  List<Reports>? vendors;

  PermissionData({
    this.activityTypes,
    this.clients,
    this.companySettings,
    this.consultants,
    this.contractors,
    this.cost,
    this.dashboard,
    this.departments,
    this.email,
    this.employees,
    this.leaves,
    this.leaveTypes,
    this.payroll,
    this.permissions,
    this.projects,
    this.reports,
    this.roles,
    this.salarySettings,
    this.timeTracking,
    this.vendors,
  });

  PermissionData.fromJson(Map<String, dynamic> json) {
    activityTypes = _parseReportsList(json['activity_types']);
    clients = _parseReportsList(json['clients']);
    companySettings = _parseReportsList(json['company_settings']);
    consultants = _parseReportsList(json['consultants']);
    contractors = _parseReportsList(json['contractors']);
    cost = _parseReportsList(json['cost']);
    dashboard = _parseReportsList(json['dashboard']);
    departments = _parseReportsList(json['departments']);
    email = _parseReportsList(json['email']);
    employees = _parseReportsList(json['employees']);
    leaves = _parseReportsList(json['leaves']);
    leaveTypes = _parseReportsList(json['leave_types']);
    payroll = _parseReportsList(json['payroll']);
    permissions = _parseReportsList(json['permissions']);
    projects = _parseReportsList(json['projects']);
    reports = _parseReportsList(json['reports']);
    roles = _parseReportsList(json['roles']);
    salarySettings = _parseReportsList(json['salary_settings']);
    timeTracking = _parseReportsList(json['time_tracking']);
    vendors = _parseReportsList(json['vendors']);
  }

  List<Reports>? _parseReportsList(dynamic json) {
    if (json == null || json is! List) return null;
    return json.map((v) => Reports.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activityTypes != null) {
      data['activity_types'] = activityTypes!.map((v) => v.toJson()).toList();
    }
    if (clients != null) {
      data['clients'] = clients!.map((v) => v.toJson()).toList();
    }
    if (companySettings != null) {
      data['company_settings'] = companySettings!.map((v) => v.toJson()).toList();
    }
    if (consultants != null) {
      data['consultants'] = consultants!.map((v) => v.toJson()).toList();
    }
    if (contractors != null) {
      data['contractors'] = contractors!.map((v) => v.toJson()).toList();
    }
    if (cost != null) {
      data['cost'] = cost!.map((v) => v.toJson()).toList();
    }
    if (dashboard != null) {
      data['dashboard'] = dashboard!.map((v) => v.toJson()).toList();
    }
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    if (email != null) {
      data['email'] = email!.map((v) => v.toJson()).toList();
    }
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    if (leaves != null) {
      data['leaves'] = leaves!.map((v) => v.toJson()).toList();
    }
    if (leaveTypes != null) {
      data['leave_types'] = leaveTypes!.map((v) => v.toJson()).toList();
    }
    if (payroll != null) {
      data['payroll'] = payroll!.map((v) => v.toJson()).toList();
    }
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    if (projects != null) {
      data['projects'] = projects!.map((v) => v.toJson()).toList();
    }
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    if (salarySettings != null) {
      data['salary_settings'] = salarySettings!.map((v) => v.toJson()).toList();
    }
    if (timeTracking != null) {
      data['time_tracking'] = timeTracking!.map((v) => v.toJson()).toList();
    }
    if (vendors != null) {
      data['vendors'] = vendors!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// Get all permissions as flat list
  List<Reports> getAllPermissions() {
    return [
      ...(activityTypes ?? []),
      ...(clients ?? []),
      ...(companySettings ?? []),
      ...(consultants ?? []),
      ...(contractors ?? []),
      ...(cost ?? []),
      ...(dashboard ?? []),
      ...(departments ?? []),
      ...(email ?? []),
      ...(employees ?? []),
      ...(leaves ?? []),
      ...(leaveTypes ?? []),
      ...(payroll ?? []),
      ...(permissions ?? []),
      ...(projects ?? []),
      ...(reports ?? []),
      ...(roles ?? []),
      ...(salarySettings ?? []),
      ...(timeTracking ?? []),
      ...(vendors ?? []),
    ];
  }
}

class Reports {
  int? id;
  String? permissionKey;
  String? label;
  String? description;

  Reports({this.id, this.permissionKey, this.label, this.description});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permissionKey = json['permission_key'];
    label = json['label'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['permission_key'] = permissionKey;
    data['label'] = label;
    data['description'] = description;
    return data;
  }
}

class Tokens {
  String? accessToken;
  String? refreshToken;

  Tokens({this.accessToken, this.refreshToken});

  Tokens.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
