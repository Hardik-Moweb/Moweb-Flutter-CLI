class ProfileModel {
  bool? success;
  int? code;
  String? message;
  ProfileData? data;

  ProfileModel({this.success, this.code, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  int? createdBy;
  String? updatedBy;
  String? deletedBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? id;
  int? companyId;
  int? employeeId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImage;
  String? lastLoginAt;
  String? slug;
  Role? role;
  String? roleName;
  String? departmentName;
  String? countryCode;

  ProfileData(
      {this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.id,
        this.companyId,
        this.employeeId,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.profileImage,
        this.lastLoginAt,
        this.slug,
        this.role,
        this.roleName,
        this.departmentName,
        this.countryCode});

  ProfileData.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    id = json['id'];
    companyId = json['company_id'];
    employeeId = json['employee_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    lastLoginAt = json['last_login_at'];
    slug = json['slug'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    roleName = json['role_name'];
    departmentName = json['department_name'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted_by'] = deletedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['id'] = id;
    data['company_id'] = companyId;
    data['employee_id'] = employeeId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_image'] = profileImage;
    data['last_login_at'] = lastLoginAt;
    data['slug'] = slug;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['role_name'] = roleName;
    data['department_name'] = departmentName;
    data['country_code'] = countryCode;
    return data;
  }
}

class Role {
  int? createdBy;
  Null updatedBy;
  Null deletedBy;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;
  int? id;
  String? name;
  int? companyId;
  int? status;

  Role(
      {this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.id,
        this.name,
        this.companyId,
        this.status});

  Role.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted_by'] = deletedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['id'] = id;
    data['name'] = name;
    data['company_id'] = companyId;
    data['status'] = status;
    return data;
  }
}
