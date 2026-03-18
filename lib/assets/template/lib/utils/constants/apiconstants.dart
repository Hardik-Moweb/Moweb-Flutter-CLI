import 'package:{{project_name}}/config/env_service.dart';

class URLS {
  /* Client End Server*/
  static String baseUrl = EnvService().baseUrl;
  static String logIn = "auth/auth/login";
  static String userDetail = "auth/auth/userDetail";
  static String updateProfile = "auth/auth/updateProfile";
  static String refreshToken = "auth/auth/refreshToken";
}

class ARG {
  static String dropDown = 'drop-down';
  static String refreshToken = 'refresh_token';
  static String email = 'email';
  static String password = 'password';
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String contactNo = 'contact_no';
}
