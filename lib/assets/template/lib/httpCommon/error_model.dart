class ErrorModel {
  List<Errors>? errors;

  ErrorModel({this.errors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String? field;
  String? type;
  String? message;

  Errors({this.field, this.type, this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}
