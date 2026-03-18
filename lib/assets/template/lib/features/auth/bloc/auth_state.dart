part of 'auth_bloc.dart';

class AuthInitial extends AuthState {}

class AuthState {
  // Login states
  final ApiCallState? loginCallState;
  final String? loginErrorMessage;
  final LoginResponseModel? loginModel;

  // User detail states
  final ApiCallState? userDetailCallState;
  final String? userDetailErrorMessage;
  final ProfileModel? profileModel;

  // Update profile states
  final ApiCallState? updateProfileCallState;
  final String? updateProfileErrorMessage;
  final SuccessModel? updateProfileResponse;

  // Profile form states
  final bool isLocalDataLoaded;
  final String roleValue;
  final String departmentValue;

  AuthState({
    this.loginCallState = ApiCallState.none,
    this.loginErrorMessage,
    this.loginModel,
    
    this.userDetailCallState = ApiCallState.none,
    this.userDetailErrorMessage,
    this.profileModel,
    
    this.updateProfileCallState = ApiCallState.none,
    this.updateProfileErrorMessage,
    this.updateProfileResponse,
    
    this.isLocalDataLoaded = false,
    this.roleValue = "Employee",
    this.departmentValue = "UI Designer",
  });

  List<Object?> get props => [
    loginCallState,
    loginErrorMessage,
    loginModel,
    
    userDetailCallState,
    userDetailErrorMessage,
    profileModel,
    
    updateProfileCallState,
    updateProfileErrorMessage,
    updateProfileResponse,
    
    isLocalDataLoaded,
    roleValue,
    departmentValue,
  ];

  AuthState copyWith({
    ApiCallState? loginCallState,
    String? loginErrorMessage,
    LoginResponseModel? loginModel,
    
    ApiCallState? userDetailCallState,
    String? userDetailErrorMessage,
    ProfileModel? profileModel,
    
    ApiCallState? updateProfileCallState,
    String? updateProfileErrorMessage,
    SuccessModel? updateProfileResponse,
    
    bool? isLocalDataLoaded,
    String? roleValue,
    String? departmentValue,
  }) {
    return AuthState(
      loginCallState: loginCallState ?? this.loginCallState,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      loginModel: loginModel ?? this.loginModel,
      
      userDetailCallState: userDetailCallState ?? this.userDetailCallState,
      userDetailErrorMessage: userDetailErrorMessage ?? this.userDetailErrorMessage,
      profileModel: profileModel ?? this.profileModel,
      
      updateProfileCallState: updateProfileCallState ?? this.updateProfileCallState,
      updateProfileErrorMessage: updateProfileErrorMessage ?? this.updateProfileErrorMessage,
      updateProfileResponse: updateProfileResponse ?? this.updateProfileResponse,
      
      isLocalDataLoaded: isLocalDataLoaded ?? this.isLocalDataLoaded,
      roleValue: roleValue ?? this.roleValue,
      departmentValue: departmentValue ?? this.departmentValue,
    );
  }
}