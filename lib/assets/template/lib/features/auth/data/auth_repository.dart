import 'package:{{project_name}}/features/auth/models/success_model.dart';
import 'package:{{project_name}}/httpCommon/api_result.dart';
import 'package:{{project_name}}/httpCommon/my_app_http.dart';
import 'package:{{project_name}}/features/auth/data/auth_datasource.dart';
import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:{{project_name}}/features/auth/models/profile_model.dart';

class AuthRepository {
  AuthRepository({
    required AuthDataSource authDataSource,
  }) : _authDataSource = authDataSource;

  final AuthDataSource _authDataSource;

  // Login Repository
  Future<ApiResult<LoginResponseModel>> login(String email, String password) async {
    final result = await _authDataSource.login(email, password);
    LoginResponseModel responseData = LoginResponseModel.fromJson(result!.data);
    return checkResponseStatusCode<LoginResponseModel>(result, responseData);
  }

  // User Detail Repository
  Future<ApiResult<ProfileModel>> getUserDetail() async {
    final result = await _authDataSource.getUserDetail();
    ProfileModel profileModel = ProfileModel.fromJson(result!.data);
    return checkResponseStatusCode<ProfileModel>(result, profileModel);
  }

  // Update Profile Repository
  Future<SuccessModel> updateProfile(
    String firstName,
    String lastName,
    String phone,
    String image,
    bool isRemoveProfile
  ) async {
    final result = await _authDataSource.updateProfile(
      firstName,
      lastName,
      phone,
      image,
      isRemoveProfile
    );
    SuccessModel responseData = SuccessModel.fromJson(result!.data);
    return responseData;
  }
}