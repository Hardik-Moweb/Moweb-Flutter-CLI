class BaseResponse {
  int? count;
  String? next;
  String? previous;
  BaseErrors? errors;

  BaseResponse({this.count, this.next, this.previous});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['error'] != null) {
      errors = BaseErrors.fromJson(json['error']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    return data;
  }
}

class BaseErrors {
  String? field;
  String? errorMessage;
  int? code;

  BaseErrors({this.field, this.errorMessage, this.code});

  BaseErrors.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    if (json['error_message'] is Map) {
      errorMessage =
          "${json['field']} ${json['error_message'].values.toList()[0][0]}";
    } else {
      errorMessage = json['error_message'];
    }

    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['error_message'] = errorMessage;
    data['code'] = code;
    return data;
  }
}
