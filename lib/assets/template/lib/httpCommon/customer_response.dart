import 'package:{{project_name}}/httpCommon/base_response.dart';

class CustomerResponse extends BaseResponse {
  int? id;
  String? logoThumbnail;
  String? businessName;
  String? type;
  String? natureOfBusiness;
  String? operationsSince;
  String? size;
  String? categoryName;
  List<Tag>? tags;
  String? status;
  String? address;
  String? district;
  String? ward;
  String? street;
  String? pinCode;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? dobOfPromoter;
  //AddressTypesEnum? premisesType;
  String? creditRange;
  String? creditAmountCap;
  String? creditCycle;
  String? note;
  String? priorRelationship;
  String? personalFamilySize;
  String? contactNo;
  String? billingBusinessName;
  String? billingWard;
  String? billingStreet;
  String? billingAddress;
  String? billingDistrict;
  String? billingPinCode;
  String? capturedLatitude;
  String? capturedLongitude;
  List<BillingTaxesInformation>? billingTaxesInformation;
  VerificationStatuses? verificationStatuses;
  List<OtherDocuments>? otherDocuments;
  RegBy? regBy;
  String? warehouseName;

  CustomerResponse({
    this.id,
    this.logoThumbnail,
    this.businessName,
    this.type,
    this.natureOfBusiness,
    this.operationsSince,
    this.size,
    this.categoryName,
    this.tags,
    this.status,
    this.address,
    this.district,
    this.ward,
    this.street,
    this.pinCode,
    this.name,
    this.email,
    this.dobOfPromoter,
    //this.premisesType,
    this.creditRange,
    this.creditAmountCap,
    this.creditCycle,
    this.note,
    this.priorRelationship,
    this.personalFamilySize,
    this.contactNo,
    this.verificationStatuses,
    this.billingBusinessName,
    this.billingWard,
    this.billingStreet,
    this.billingAddress,
    this.billingDistrict,
    this.billingPinCode,
    this.billingTaxesInformation,
    this.otherDocuments,
    this.capturedLatitude,
    this.capturedLongitude,
    this.lastName,
    this.firstName,
    this.regBy,
    this.warehouseName,
  });

  CustomerResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoThumbnail = json['logo_thumbnail'];
    businessName = json['business_name'];
    type = json['type'];
    natureOfBusiness = json['nature_of_business'];
    operationsSince = json['operations_since'];
    size = json['size'];
    categoryName = json['category_name'];
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    status = json['status'];
    address = json['address'];
    district = json['district'];
    ward = json['ward'];
    street = json['street'];
    pinCode = json['pin_code'];
    name = json['name'];
    email = json['email'];
    dobOfPromoter = json['dob_of_promoter'];
    // premisesType = json['premises_type']
    //     .toString()
    //     .toEnum<AddressTypesEnum>(AddressTypesEnum.values);
    creditRange = json['credit_range'];
    creditAmountCap = json['credit_amount_cap'];
    creditCycle = json['credit_cycle'];
    note = json['note'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    priorRelationship = json['prior_relationship'];
    personalFamilySize = json['personal_family_size'];
    capturedLatitude = json['captured_latitude'];
    capturedLongitude = json['captured_longitude'];
    contactNo = json['contact_no'];
    verificationStatuses = json['verification_statuses'] != null
        ? VerificationStatuses.fromJson(json['verification_statuses'])
        : null;
    if (json['other_documents'] != null) {
      otherDocuments = <OtherDocuments>[];
      json['other_documents'].forEach((v) {
        otherDocuments!.add(OtherDocuments.fromJson(v));
      });
    }
    billingBusinessName = json['billing_business_name'];
    billingWard = json['billing_ward'];
    billingStreet = json['billing_street'];
    billingAddress = json['billing_address'];
    billingDistrict = json['billing_district'];
    billingPinCode = json['billing_pin_code'];
    if (json['billing_taxes_information'] != null) {
      billingTaxesInformation = <BillingTaxesInformation>[];
      json['billing_taxes_information'].forEach((v) {
        billingTaxesInformation!.add(BillingTaxesInformation.fromJson(v));
      });
    }
    regBy = json['reg_by'] != null ? RegBy.fromJson(json['reg_by']) : null;
    warehouseName = json['warehouse_name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo_thumbnail'] = logoThumbnail;
    data['business_name'] = businessName;
    data['type'] = type;
    data['nature_of_business'] = natureOfBusiness;
    data['operations_since'] = operationsSince;
    data['size'] = size;
    data['category_name'] = categoryName;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['address'] = address;
    data['district'] = district;
    data['ward'] = ward;
    data['street'] = street;
    data['pin_code'] = pinCode;
    data['name'] = name;
    data['email'] = email;
    data['dob_of_promoter'] = dobOfPromoter;
    //data['premises_type'] = premisesType;
    data['credit_range'] = creditRange;
    data['credit_amount_cap'] = creditAmountCap;
    data['credit_cycle'] = creditCycle;
    data['note'] = note;
    data['prior_relationship'] = priorRelationship;
    data['captured_latitude'] = capturedLatitude;
    data['captured_longitude'] = capturedLongitude;
    data['personal_family_size'] = personalFamilySize;
    data['contact_no'] = contactNo;
    data['first_name'] = firstName;
    data['last_name'] = lastName;

    if (verificationStatuses != null) {
      data['verification_statuses'] = verificationStatuses!.toJson();
    }
    if (otherDocuments != null) {
      data['other_documents'] = otherDocuments!.map((v) => v.toJson()).toList();
    }
    data['billing_business_name'] = billingBusinessName;
    data['billing_ward'] = billingWard;
    data['billing_street'] = billingStreet;
    data['billing_address'] = billingAddress;
    data['billing_district'] = billingDistrict;
    data['billing_pin_code'] = billingPinCode;
    if (billingTaxesInformation != null) {
      data['billing_taxes_information'] =
          billingTaxesInformation!.map((v) => v.toJson()).toList();
    }
    if (regBy != null) {
      data['reg_by'] = regBy!.toJson();
    }
    return data;
  }

  // bool get isStationry => premisesType == AddressTypesEnum.stationary;
  // bool get isMoveable => premisesType == AddressTypesEnum.movable;
}

class Tag {
  int? tagId;
  String? tagName;

  Tag({this.tagId, this.tagName});

  Tag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag_id'] = tagId;
    data['tag_name'] = tagName;
    return data;
  }
}

class BillingTaxesInformation {
  int? id;
  int? taxLabelId;
  String? taxNumber;
  String? taxLabelName;

  BillingTaxesInformation(
      {this.id, this.taxLabelId, this.taxNumber, this.taxLabelName});

  BillingTaxesInformation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taxLabelId = json['tax_label_id'];
    taxNumber = json['tax_number'];
    taxLabelName = json['tax_label_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tax_label_id'] = taxLabelId;
    data['tax_number'] = taxNumber;
    data['tax_label_name'] = taxLabelName;
    return data;
  }
}

class VerificationStatuses {
  bool? contactVerified;
  bool? businessDocVerified;
  bool? businessAddressVerified;

  VerificationStatuses(
      {this.contactVerified,
      this.businessDocVerified,
      this.businessAddressVerified});

  VerificationStatuses.fromJson(Map<String, dynamic> json) {
    contactVerified = json['contact_verified'];
    businessDocVerified = json['business_doc_verified'];
    businessAddressVerified = json['business_address_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_verified'] = contactVerified;
    data['business_doc_verified'] = businessDocVerified;
    data['business_address_verified'] = businessAddressVerified;
    return data;
  }
}

class StoreFrontPhoto {
  int? id;
  String? frontPhoto;
  String? frontPhotoThumbnail;
  String? frontPhotoLatitude;
  String? frontPhotoLongitude;

  StoreFrontPhoto(
      {this.id,
      this.frontPhoto,
      this.frontPhotoThumbnail,
      this.frontPhotoLatitude,
      this.frontPhotoLongitude});

  StoreFrontPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    frontPhoto = json['front_photo'];
    frontPhotoThumbnail = json['front_photo_thumbnail'];
    frontPhotoLatitude = json['front_photo_latitude'];
    frontPhotoLongitude = json['front_photo_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['front_photo'] = frontPhoto;
    data['front_photo_thumbnail'] = frontPhotoThumbnail;
    data['front_photo_latitude'] = frontPhotoLatitude;
    data['front_photo_longitude'] = frontPhotoLongitude;
    return data;
  }
}

class StoreOtherPhoto {
  int? id;
  String? otherStorePhoto;
  String? otherStorePhotoThumbnail;
  String? otherStorePhotoLatitude;
  String? otherStorePhotoLongitude;

  StoreOtherPhoto(
      {this.id,
      this.otherStorePhoto,
      this.otherStorePhotoThumbnail,
      this.otherStorePhotoLatitude,
      this.otherStorePhotoLongitude});

  StoreOtherPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    otherStorePhoto = json['other_store_photo'];
    otherStorePhotoThumbnail = json['other_store_photo_thumbnail'];
    otherStorePhotoLatitude = json['other_store_photo_latitude'];
    otherStorePhotoLongitude = json['other_store_photo_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['other_store_photo'] = otherStorePhoto;
    data['other_store_photo_thumbnail'] = otherStorePhotoThumbnail;
    data['other_store_photo_latitude'] = otherStorePhotoLatitude;
    data['other_store_photo_longitude'] = otherStorePhotoLongitude;
    return data;
  }
}

class StoreInPhoto {
  int? id;
  String? inStorePhoto;
  String? inStorePhotoThumbnail;
  String? inStorePhotoLatitude;
  String? inStorePhotoLongitude;

  StoreInPhoto(
      {this.id,
      this.inStorePhoto,
      this.inStorePhotoThumbnail,
      this.inStorePhotoLatitude,
      this.inStorePhotoLongitude});

  StoreInPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inStorePhoto = json['in_store_photo'];
    inStorePhotoThumbnail = json['in_store_photo_thumbnail'];
    inStorePhotoLatitude = json['in_store_photo_latitude'];
    inStorePhotoLongitude = json['in_store_photo_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['in_store_photo'] = inStorePhoto;
    data['in_store_photo_thumbnail'] = inStorePhotoThumbnail;
    data['in_store_photo_latitude'] = inStorePhotoLatitude;
    data['in_store_photo_longitude'] = inStorePhotoLongitude;
    return data;
  }
}

class RegBy {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? type;

  RegBy({this.id, this.firstName, this.lastName, this.email, this.type});

  RegBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['type'] = type;
    return data;
  }
}

class CustomerCategory {
  int? id;
  String? category;
  String? masterNatureOfBusiness;

  CustomerCategory({this.id, this.category, this.masterNatureOfBusiness});

  CustomerCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    masterNatureOfBusiness = json['master_nature_of_business'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['master_nature_of_business'] = masterNatureOfBusiness;
    return data;
  }
}

class District {
  int? id;
  String? name;
  String? region;
  int? wards;
  //Null? kmlFile;

  District({
    this.id,
    this.name,
    this.region,
    this.wards,
    //this.kmlFile
  });

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    wards = json['wards'];
    //kmlFile = json['kml_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['region'] = region;
    data['wards'] = wards;
    // data['kml_file'] = this.kmlFile;
    return data;
  }
}

class Ward {
  int? id;
  String? name;

  Ward({this.id, this.name});

  Ward.fromJson(Map<String, dynamic> json) {
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

class CreditRange {
  int? id;
  String? creditRangeName;
  String? creditFrom;
  String? creditTo;

  CreditRange({this.id, this.creditRangeName, this.creditFrom, this.creditTo});

  CreditRange.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditRangeName = json['credit_range_name'];
    creditFrom = json['credit_from'];
    creditTo = json['credit_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['credit_range_name'] = creditRangeName;
    data['credit_from'] = creditFrom;
    data['credit_to'] = creditTo;
    return data;
  }
}

class Warehouse {
  int? id;
  String? name;

  Warehouse({this.id, this.name});

  Warehouse.fromJson(Map<String, dynamic> json) {
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

class CustomerTag {
  int? id;
  String? tagName;

  CustomerTag({this.id, this.tagName});

  CustomerTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag_name'] = tagName;
    return data;
  }
}

class Document {
  int? id;
  String? customerDocument;
  String? documentMIME;

  Document({this.id, this.customerDocument, this.documentMIME});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerDocument = json['customer_document'];
    documentMIME = json['document_MIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_document'] = customerDocument;
    data['document_MIME'] = documentMIME;
    return data;
  }
}

class BusinessLicenseVerifyBy {
  int? id;
  String? firstName;
  String? lastName;

  BusinessLicenseVerifyBy({this.id, this.firstName, this.lastName});

  BusinessLicenseVerifyBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

class OtherDocuments {
  int? id;
  String? document;

  OtherDocuments({this.id, this.document});

  OtherDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    document = json['document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['document'] = document;
    return data;
  }
}
