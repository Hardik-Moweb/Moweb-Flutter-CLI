import 'package:{{project_name}}/httpCommon/http_response.dart';
import 'package:{{project_name}}/httpCommon/my_app_http.dart';
import 'package:{{project_name}}/utils/constants/apiconstants.dart';

class AuthDataSource extends HttpActions {
  AuthDataSource();

  // Login API
  Future<HttpResponse?> login(String email, String password) async {
    final response = await postMethod(
      URLS.logIn,
      data: {
        ARG.email: email,
        ARG.password: password
      }
    );
    return response;
  }

  // User Detail API
  Future<HttpResponse?> getUserDetail() async {
    final response = await getMethod(
      URLS.userDetail,
    );
    return response;
  }

  // Update Profile API
  Future<HttpResponse?> updateProfile(
    String firstName,
    String lastName,
    String phone,
    String image,
    bool isRemoveProfile
  ) async {
    final response = await patchMethod(
      URLS.updateProfile,
      data: {
        ARG.firstName: firstName,
        ARG.lastName: lastName,
        ARG.contactNo: phone,
      },
    );
    return response;
  }
}