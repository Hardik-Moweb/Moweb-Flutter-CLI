import 'dart:developer';
import 'package:{{project_name}}/httpCommon/base_response.dart';


import 'package:{{project_name}}/utils/import.dart';

enum HttpRequestNames { get, post, patch, put, delete }


class ErrorHelpers {
  static String generateErrorMessage(BaseErrors error, BuildContext context) {
    return error.errorMessage ?? "";
  }
}



void apiPrint({
  String url = "",
  String headers = "",
  String request = "",
  String methodtype = "",
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("URL : $url");
  log("HEADER : $headers");
  log("REQUEST :  ($methodtype) $request");
  log("START_TIME---------${DateTime.now().toString()}");
}


void apiPrintResponse({
  String endPoint = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
}) {
  log('RESPONSE :  ($methodtype - $endPoint) $statusCode: $responseBody');
  log("END_TIME---------${DateTime.now().toString()}");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}