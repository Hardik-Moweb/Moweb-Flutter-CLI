// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:{{project_name}}/httpCommon/error_model.dart';
import 'package:{{project_name}}/httpCommon/http_response.dart';
import 'package:{{project_name}}/utils/import.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;

  const factory ApiResult.failure({required String error}) = Failure<T>;
}

class HandleAPI {
  static String handleAPIError(e) {
    try {
      if (e.toString().contains(
          "(OS Error: No address associated with hostname, errno = 7)")) {
        return MyStrings.nointernet;
      }
      return e.toString();
    } catch (e) {
      return MyStrings.somethingWentWrong;
    }
  }

  static String checkStatusCode(HttpResponse response) {
    if (response.data.toString().contains('errors')) {
      ErrorModel model = ErrorModel.fromJson(response.data);

      printLog("Display Alert dialog here.");
      return model.errors?[0].message ?? 'Something Went Wrong';
    } else {
      return "1";
    }
  }

  static String checkStatusCodeMultipart(Response response) {
    if (response.body.toString().contains('error_message')) {
      ErrorModel model = ErrorModel.fromJson(json.decode(response.body));

      printLog("Display Alert dialog here.");
      return model.errors?[0].message ?? 'Something Went Wrong';
    } else {
      return "1";
    }
  }
}
