// ignore_for_file: unused_local_variable, null_argument_to_non_null_type, duplicate_ignore
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:{{project_name}}/httpCommon/api_result.dart';
import 'package:{{project_name}}/httpCommon/error_model.dart';
import 'package:{{project_name}}/httpCommon/http_helpers.dart';
import 'package:{{project_name}}/httpCommon/http_response.dart';
import 'package:{{project_name}}/httpCommon/user_session_manager.dart';
import 'package:{{project_name}}/features/auth/screens/login_page.dart';
import 'package:{{project_name}}/utils/constants/apiconstants.dart';
import 'package:{{project_name}}/utils/global_state.dart';
import 'package:{{project_name}}/utils/import.dart';
import 'package:http/http.dart' as http;

// No longer needed imports removed

class HttpActions {
  HttpActions();

  Future<HttpResponse?> refreshTokenMethod() async {
    Map<String, String>? headers = {};


    // Get the refresh token from SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? refreshToken = sharedPreferences.getString(
      PreferenceKey.prefAccessToken,
    );

    if (refreshToken?.isNotEmpty == true) {
      headers["Authorization"] = "$refreshToken";
    }
    if ((await checkConnection()).first != ConnectivityResult.none) {
      apiPrint(
        url: Uri.parse(URLS.baseUrl + URLS.refreshToken).toString(),
        headers: jsonEncode(headers),
        methodtype: "POST",
      );

      http.Response response = await http.post(
        Uri.parse(URLS.baseUrl + URLS.refreshToken),
        body: {},
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "POST",
        endPoint: URLS.refreshToken,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      if (!isAuthenticated(response.statusCode)) {
        try {
          String enCodedStr = utf8.decode(response.bodyBytes);
          printLog(response.statusCode.toString());
          log(response.body.toString());
          HttpResponse resp = HttpResponse(response.statusCode);
          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {}
    } else {
      showToast(MyStrings.nointernet);
      return Future.error(MyStrings.nointernet);
    }
    return null;
  }

  /// Update both access token and refresh token in SharedPreferences
  Future<void> _updateTokens(Map<String, dynamic> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Update access token
    if (data["access_token"] != null) {
      await sharedPreferences.setString(
        PreferenceKey.prefAccessToken,
        data["access_token"],
      );
      globalState.userData!.accessToken = data["access_token"];
      log("Updated access token: ${data["access_token"]}");
    }

    // Update refresh token
    if (data["refresh_token"] != null) {
      await sharedPreferences.setString(
        PreferenceKey.prefAccessToken,
        data["refresh_token"],
      );
      log("Updated refresh token: ${data["refresh_token"]}");
    }
  }

  Future<String?> refreshTokenAPICall(headers) async {
    // We don't need to get the refresh token here since refreshTokenMethod will handle it
    await refreshTokenMethod().then((res) {
      if (res != null) {
        if (res.data["status"] == 200 || res.data["code"] == 200) {
          // Update both tokens
          _updateTokens(res.data["data"]);
          return res.data["data"]["access_token"];
        }
      }
      return null;
    });
    return null;
  }

  Future<HttpResponse?> postMethod(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    if ((await checkConnection()).first != ConnectivityResult.none) {
      headers = await getSessionData(headers ?? {});
      final enCodedData = jsonEncode(data);

      apiPrint(
        url: Uri.parse(URLS.baseUrl + url).toString(),
        headers: jsonEncode(headers),
        request: jsonEncode(data),
        methodtype: "POST",
      );

      http.Response response = await http.post(
        Uri.parse(URLS.baseUrl + url),
        body: enCodedData,
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "POST",
        endPoint: url,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      if (!isAuthenticated(response.statusCode)) {
        try {
          String enCodedStr = utf8.decode(response.bodyBytes);
          printLog(response.statusCode.toString());
          log(response.body.toString());
          HttpResponse resp = HttpResponse(response.statusCode);
          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {
        // //Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200 || res.data["code"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            // Update both tokens
            await _updateTokens(res.data["data"]);
            return await postMethod(url, headers: headers, data: data);
          }
        }
      }
    } else {
      var result = await Navigator.push(
        GlobalVariable.navState.currentContext!,
        MaterialPageRoute(builder: (context) => const NoInternetScreen()),
      );
      return postMethod(url, headers: headers, data: data);
    }
    return null;
  }

  Future<HttpResponse?> getMethod(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParam,
    bool? isGoogleAPI,
  }) async {
    if ((await checkConnection()).first != ConnectivityResult.none) {
      headers = await getSessionData(headers ?? {});
      String queryParamStr = "";
      if (queryParam != null) {
        queryParam.forEach((key, value) {
          if (queryParamStr.isEmpty) {
            queryParamStr += "?$key=$value";
          } else {
            queryParamStr += "&$key=$value";
          }
        });
      }
      String finalEndPoint = isGoogleAPI == true ? url : URLS.baseUrl + url;
      if (queryParamStr.isNotEmpty) {
        finalEndPoint += queryParamStr;
      }
      apiPrint(
        url: finalEndPoint.toString(),
        headers: jsonEncode(headers),
        request: "",
        methodtype: "GET",
      );
      http.Response response = await http.get(
        Uri.parse(finalEndPoint),
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "GET",
        endPoint: finalEndPoint,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      if (!isAuthenticated(response.statusCode)) {
        try {
          log(response.statusCode.toString());
          log(response.body.toString());
          String enCodedStr = utf8.decode(response.bodyBytes);
          HttpResponse resp = HttpResponse(response.statusCode);
          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {
        // print("GET_HERE-------2");

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200 || res.data["code"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            // Update both tokens
            await _updateTokens(res.data["data"]);
            return await getMethod(
              url,
              headers: headers,
              queryParam: queryParam,
            );
          }
        }
      }
    } else {
      var result = await Navigator.push(
        GlobalVariable.navState.currentContext!,
        MaterialPageRoute(builder: (context) => const NoInternetScreen()),
      );

      return await getMethod(url, headers: headers, queryParam: queryParam);
    }
    return null;
  }

  bool isAuthenticated(int statusCode) {
    try {
      if (statusCode == 401) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }

    //return false;
  }

  Future<HttpResponse?> iOTPostMethod(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    //if ((await checkConnection()) != ConnectivityResult.none) {
    headers = await getSessionData(headers ?? {});
    printLog("URL-----> ${Uri.parse(url)}");
    // printLog("header - $headers");
    final enCodedData = jsonEncode(data);
    printLog("Requested Params- $enCodedData");
    http.Response response = await http.post(
      Uri.parse(url),
      body: enCodedData,
      headers: headers,
    );

    if (!isAuthenticated(response.statusCode)) {
      try {
        String enCodedStr = utf8.decode(response.bodyBytes);
        printLog(response.statusCode.toString());
        printLog(response.body.toString());
        HttpResponse resp = HttpResponse(response.statusCode);
        if (enCodedStr.isNotEmpty) {
          resp.data = jsonDecode(utf8.decode(response.bodyBytes));
        }
        return resp;
      } catch (e) {
        return Future.error(MyStrings.somethingWentWrong);
      }
    } else {
      var decoded = ErrorModel.fromJson(json.decode(response.body));
      dynamic result = await loginExpiredDialog();
      if (result != null && result == true) {
        userSessionManager.clearUserData();
        dynamic loginResult = await callNextScreenWithResult(
          GlobalVariable.navState.currentContext!,
          const LoginPage(),
        );
        if (result != null && result == true) {
          return await postMethod(url, headers: headers, data: data);
        }
      }
    }
    return null;
  }



  Future<HttpResponse?> patchMethod(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    if ((await checkConnection()).first != ConnectivityResult.none) {
      headers = await getSessionData(headers ?? {});

      final enCodedData = jsonEncode(data);

      apiPrint(
        url: Uri.parse(URLS.baseUrl + url).toString(),
        headers: jsonEncode(headers),
        request: jsonEncode(data),
        methodtype: "PATCH",
      );

      http.Response response = await http.patch(
        Uri.parse(URLS.baseUrl + url),
        body: enCodedData,
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "PATCH",
        endPoint: url,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      printLog(response.body);
      if (!isAuthenticated(response.statusCode)) {
        try {
          String enCodedStr = utf8.decode(response.bodyBytes);
          HttpResponse resp = HttpResponse(response.statusCode);
          printLog(response.statusCode.toString());
          printLog(response.body.toString());

          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {
        // //Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200 || res.data["code"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            // Update both tokens
            await _updateTokens(res.data["data"]);
            return await patchMethod(url, headers: headers, data: data);
          }
        }
      }
    } else {
      return Future.error(MyStrings.nointernet);
    }
    return null;
  }

  Future<HttpResponse?> putMethod(
    String url, {
    dynamic data,
    Map<String, String>? headers,
    String? fullUrl = "",
    bool? emptyHeader,
  }) async {
    if ((await checkConnection()).first != ConnectivityResult.none) {
      headers = (emptyHeader ?? false)
          ? {}
          : await getSessionData(headers ?? {});
      final enCodedData = jsonEncode(data);

      apiPrint(
        url: Uri.parse(
          (fullUrl!.isEmpty) ? URLS.baseUrl + url : fullUrl,
        ).toString(),
        headers: jsonEncode(headers),
        request: jsonEncode(data),
        methodtype: "PUT",
      );

      http.Response response = await http.put(
        Uri.parse((fullUrl.isEmpty) ? URLS.baseUrl + url : fullUrl),
        body: (fullUrl.isEmpty) ? enCodedData : data,
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "PUT",
        endPoint: url,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      if (!isAuthenticated(response.statusCode)) {
        try {
          String enCodedStr = utf8.decode(response.bodyBytes);
          HttpResponse resp = HttpResponse(response.statusCode);
          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {
        // //Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200 || res.data["code"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            // Update both tokens
            await _updateTokens(res.data["data"]);
            return await putMethod(url, headers: headers, data: data);
          }
        }
      }
    } else {
      return Future.error(MyStrings.nointernet);
    }
    return null;
  }

  Future<HttpResponse?> deleteMethod(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    if ((await checkConnection()).first != ConnectivityResult.none) {
      headers = await getSessionData(headers ?? {});
      final enCodedData = jsonEncode(data);

      apiPrint(
        url: Uri.parse(URLS.baseUrl + url).toString(),
        headers: jsonEncode(headers),
        request: jsonEncode(data),
        methodtype: "DELETE",
      );

      http.Response response = await http.delete(
        Uri.parse(URLS.baseUrl + url),
        body: enCodedData,
        headers: headers,
      );

      apiPrintResponse(
        methodtype: "DELETE",
        endPoint: url,
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      if (!isAuthenticated(response.statusCode)) {
        try {
          String enCodedStr = utf8.decode(response.bodyBytes);
          HttpResponse resp = HttpResponse(response.statusCode);
          if (enCodedStr.isNotEmpty) {
            resp.data = jsonDecode(utf8.decode(response.bodyBytes));
          }
          return resp;
        } catch (e) {
          return Future.error(MyStrings.somethingWentWrong);
        }
      } else {
        ///Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200 || res.data["code"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            // Update both tokens
            await _updateTokens(res.data["data"]);
            return await deleteMethod(url, headers: headers, data: data);
          }
        }
      }
    } else {
      return Future.error(MyStrings.nointernet);
    }
    return null;
  }

  //API Call with multipart

  Future<HttpClientResponse> fileUploadMultipartWithProcess(
    String url,
    Map<String, dynamic> body,
    List<String> filePaths,
    List<String> fileKeys, {
    Function(int sentBytes, int totalBytes)? onUploadProgressCallback,
  }) async {
    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse(URLS.baseUrl + url));
    int byteCount = 0;

    List<http.MultipartFile> newImageList = <http.MultipartFile>[];
    for (int i = 0; i < filePaths.length; i++) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        fileKeys[i],
        filePaths[i].toString(),
      );
      newImageList.add(multipartFile);
    }
    var requestMultipart = http.MultipartRequest(
      "POST",
      Uri.parse(URLS.baseUrl + url),
    );
    requestMultipart.files.addAll(newImageList);
    for (var entry in body.entries) {
      requestMultipart.fields[entry.key] = entry.value.toString();
    }
    Map<String, String> header = await getMultipartSessionData({});
    requestMultipart.headers.addAll(header);

    var msStream = requestMultipart.finalize();
    var totalByteLength = requestMultipart.contentLength;
    request.contentLength = totalByteLength;
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader] ?? "",
    );
    request.headers.set(
      HttpHeaders.authorizationHeader,
      requestMultipart.headers[HttpHeaders.authorizationHeader] ?? "",
    );

    request.headers.set('APP-VERSION', globalState.appVersion);
    request.headers.set('DEVICE-TYPE', Platform.isAndroid ? "Android" : 'iOS');
    request.headers.set('DEVICE-ID', "deviceId");
    request.headers.set(
      'USER-ID',
      'id',
      // userData != null ? userData?.id.toString() ?? "" : ""
    );

    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;
          if (onUploadProgressCallback != null) {
            onUploadProgressCallback(byteCount, totalByteLength);
          }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();

          /// UPLOAD DONE;
        },
      ),
    );

    await request
        .addStream(streamUpload)
        .timeout(
          const Duration(hours: 1),
          onTimeout: () {
            // ignore: null_argument_to_non_null_type
            return Future<HttpClientResponse>.value(null);
          },
        );
    final httpResponse = await request.close().timeout(
      const Duration(hours: 1),
      onTimeout: () {
        // ignore: null_argument_to_non_null_type
        return Future<HttpClientResponse>.value(null);
      },
    );
    var statusCode = httpResponse.statusCode;
    printLog("statusCodestatusCodestatusCodestatusCodestatusCode");
    printLog(statusCode.toString());

    if (statusCode ~/ 100 != 2) {
      throw Exception(
        '${MyStrings.somethingWentWrong} : ${httpResponse.statusCode}',
      );
    } else {
      return httpResponse;
    }
  }

  Future<Map<String, dynamic>?> uploadImageDocument(
    String url,
    Map<String, dynamic> body,
    List<String> filePath,
    List<String> fileName,
  ) async {
    printLog("REQUEST_PARAMS $body");
    var request = http.MultipartRequest("POST", Uri.parse(URLS.baseUrl + url));
    Map<String, String> header = await getMultipartSessionData({});
    for (var entry in body.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    for (var entry in header.entries) {
      request.headers[entry.key] = entry.value;
    }
    List<http.MultipartFile> newimageList = <http.MultipartFile>[];
    for (int i = 0; i < fileName.length; i++) {
      if (filePath[i] != "") {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          fileName[i].toString(),
          filePath[i].toString(),
          // contentType: ContentType.parse("JPEG")
        );
        newimageList.add(multipartFile);
      }
    }
    request.files.addAll(newimageList);

    apiPrint(
      url: Uri.parse(URLS.baseUrl + url).toString(),
      headers: jsonEncode(header),
      request: jsonEncode(body),
      methodtype: "UPLOAD_IMAGE",
    );

    try {
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 1400),
      );

      if (!isAuthenticated(streamedResponse.statusCode)) {
        var responseString = await streamedResponse.stream.bytesToString();
        var responseJson = json.decode(responseString);
        return responseJson;
      } else {
        // //Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            sharedPreferences.setString(
              PreferenceKey.prefAccessToken,
              res.data["data"]["access_token"],
            );
            globalState.userData!.accessToken =
                res.data["data"]["access_token"];
            return await uploadImageDocument(url, body, filePath, fileName);
          }
        }
      }
    } on TimeoutException catch (e) {
      printLog('Request timed out: $e');
    } on http.ClientException catch (e) {
      printLog('Client exception: $e');
    } on SocketException catch (e) {
      printLog('Socket exception: $e');
    } catch (e) {
      printLog('Unknown error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> putAPICallWithMultipartArray(
    String url, {
    Map<String, dynamic>? body,
    List<String>? filePath,
    List<String>? fileName,
  }) async {
    var request = http.MultipartRequest("PUT", Uri.parse(URLS.baseUrl + url));
    Map<String, String> header = await getMultipartSessionData({});
    for (var entry in body!.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    for (var entry in header.entries) {
      request.headers[entry.key] = entry.value;
    }
    List<http.MultipartFile> newimageList = <http.MultipartFile>[];
    if (filePath!.isNotEmpty) {
      for (int i = 0; i < fileName!.length; i++) {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          fileName[i].toString(),
          filePath[i].toString(),
        );
        newimageList.add(multipartFile);
      }
    }
    if (newimageList.isNotEmpty) {
      request.files.addAll(newimageList);
    }

    try {
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 1400),
      );

      if (!isAuthenticated(streamedResponse.statusCode)) {
        var responseString = await streamedResponse.stream.bytesToString();
        printLog("RESPONSE-----------${responseString.toString()}");
        var responseJson = json.decode(responseString);
        return responseJson;
      } else {
        // //Refresh Token API call
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? refreshToken = sharedPreferences.getString(
          PreferenceKey.prefAccessToken,
        );
        HttpResponse? res = await refreshTokenMethod();
        if (res != null) {
          if (res.data["status"] == 200) {
            log("REFRESH_RESPONSE_CALL----${res.data["data"]["access_token"]}");
            sharedPreferences.setString(
              PreferenceKey.prefAccessToken,
              res.data["data"]["access_token"],
            );
            globalState.userData!.accessToken =
                res.data["data"]["access_token"];
            return await putAPICallWithMultipartArray(
              url,
              body: body,
              fileName: fileName,
              filePath: filePath,
            );
          }
        }
      }
    } on TimeoutException catch (e) {
      printLog('Request timed out: $e');
    } on http.ClientException catch (e) {
      printLog('Client exception: $e');
    } on SocketException catch (e) {
      printLog('Socket exception: $e');
    } catch (e) {
      printLog('Unknown error: $e');
    }
    return null;

    /*  try {
      var streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 1400), onTimeout: () {
        return Future<http.StreamedResponse>.value(null);
      });
      try {
        var response = await http.Response.fromStream(streamedResponse);

        String enCodedStr = utf8.decode(response.bodyBytes);
        HttpResponse resp = HttpResponse(response.statusCode);
        if (enCodedStr.isNotEmpty) {
          resp.data = jsonDecode(utf8.decode(response.bodyBytes));
        }
        return resp;
      } catch (e) {
        return Future.error(MyStrings.somethingWentWrong);
      }
    } on Exception {
      printLog("Exception ");
      return null;
    }

    */
  }

  Future<HttpResponse?> patchAPICallWithMultipartArray(
    String url,
    Map<String, dynamic> body,
    List<String> filePath,
    List<String> fileName,
  ) async {
    printLog("REQUEST_PARAMS $body");
    var request = http.MultipartRequest("PATCH", Uri.parse(url));
    Map<String, String> header = await getMultipartSessionData({});
    for (var entry in body.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    for (var entry in header.entries) {
      request.headers[entry.key] = entry.value;
    }
    List<http.MultipartFile> newimageList = <http.MultipartFile>[];
    for (int i = 0; i < fileName.length; i++) {
      if (filePath[i] != "") {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          fileName[i],
          filePath[i],
        );
        newimageList.add(multipartFile);
      }
    }
    request.files.addAll(newimageList);

    apiPrint(
      url: Uri.parse(URLS.baseUrl + url).toString(),
      headers: jsonEncode(header),
      request: jsonEncode(request),
      methodtype: "PATCH_MULTIPART",
    );

    try {
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 1400),
        onTimeout: () {
          return Future<http.StreamedResponse>.value(null);
        },
      );
      try {
        var response = await http.Response.fromStream(streamedResponse);

        String enCodedStr = utf8.decode(response.bodyBytes);
        HttpResponse resp = HttpResponse(response.statusCode);
        if (enCodedStr.isNotEmpty) {
          resp.data = jsonDecode(utf8.decode(response.bodyBytes));
        }
        return resp;
      } catch (e) {
        return Future.error(MyStrings.somethingWentWrong);
      }
    } on Exception {
      printLog("Exception ");
      return null;
    }
  }

  Future<void> download(
    String url, {
    required Function(int totalBytes, int receivedBytes) onDownloadProgress,
    required Function(List<int> totalBytes) onDownloadDone,
  }) async {
    final streamedRequest = http.StreamedRequest("GET", Uri.parse(url));
    streamedRequest.headers.addAll(await getSessionData({}));
    var totalLength = streamedRequest.contentLength;
    Stream.value("")
        // Transform the string-stream to a byte stream (List<int>)
        .transform(utf8.encoder)
        // Start reading the stream in chunks, submitting them to the streamedRequest for upload
        .listen(
          (chunk) {
            streamedRequest.sink.add(chunk);
          },
          onDone: () {
            streamedRequest.sink.close();
          },
        );

    int total = 0, received = 0;
    final List<int> bytes = [];

    http.StreamedResponse response = await http.Client().send(streamedRequest);

    response.stream.listen(
      (value) {
        bytes.addAll(value);
        received += value.length;
        onDownloadProgress(total, received);
      },
      onDone: () {
        onDownloadDone(bytes);
      },
    );
  }

  Future<Map<String, String>> getSessionData(
    Map<String, String> headers,
  ) async {
    // LoginResponseData? sessionData = await getUserData();
    // sessionData = await getUserData();

    String? accessToken = await userSessionManager.getAccessToken();
    String? deviceId = await userSessionManager.getDeviceId();

    headers["Content-Type"] = "application/json";
    if (accessToken?.isNotEmpty == true) {
      headers["Authorization"] = "$accessToken";
    }
    headers['APP-VERSION'] = globalState.appVersion;
    headers['device-type'] = Platform.isAndroid ? "Android" : 'iOS';
    headers['DEVICE-ID'] = deviceId ?? "";
    return headers;
  }

  Future<Map<String, String>> getMultipartSessionData(
    Map<String, String> headers,
  ) async {
    String? accessToken = await userSessionManager.getAccessToken();
    String? deviceId = await userSessionManager.getDeviceId();

    headers["Content-Type"] = "multipart/form-data";
    if (accessToken?.isNotEmpty == true) {
      headers["Authorization"] = "Bearer $accessToken";
    }
    headers['APP-VERSION'] = globalState.appVersion;
    headers['DEVICE-TYPE'] = Platform.isAndroid ? "Android" : 'iOS';
    headers['DEVICE-ID'] = deviceId ?? "";
    return headers;
  }

  Future<List<ConnectivityResult>> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;
  }
}

ApiResult<T> checkResponseStatusCode<T>(
  HttpResponse result,
  dynamic responseData,
) {
  if ((result.statusCode == 200 ||
      result.statusCode == 201 ||
      result.statusCode == 204) /*&&
      (result.data['code'] != null
          ? (result.data['code'] == 200 ||
                result.data['code'] == 201 ||
                result.data['code'] == 204)
          : true)*/ ) {
    return ApiResult.success(data: responseData as T);
  } else if (result.statusCode == 422) {
    return ApiResult.failure(
      error:
          getErrorMsg(
            (result.data['statusCode'] ?? result.data['status'].toString())
                .toString(),
          ) ??
          HandleAPI.checkStatusCode(result),
    );
  }
  ///Creator - Update due date more then requested then give alert dialog
  else if (result.statusCode == 400 &&
      (result.data['status'] == 1028 || result.data['status'] == 1032)) {
    return ApiResult.success(data: responseData as T);
  } else if (result.statusCode == 400 ||
      result.statusCode == 401 ||
      result.statusCode == 404) {
    return ApiResult.failure(
      error:
          getErrorMsg(
            (result.data['statusCode'] ?? result.data['status'].toString())
                .toString(),
          ) ??
          result.data['errors'] ??
          result.data['message'],
    );
  } else if (result.statusCode == 500) {
    return ApiResult.failure(
      error:
          getErrorMsg(
            (result.data['statusCode'] ?? result.data['status'].toString())
                .toString(),
          ) ??
          result.data,
    );
  } else {
    return ApiResult.failure(
      error: result.data['message'] ?? MyStrings.somethingWentWrong,
    );
  }
}
