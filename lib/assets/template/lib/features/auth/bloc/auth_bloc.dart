import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name}}/features/auth/models/success_model.dart';
import 'package:{{project_name}}/features/auth/data/auth_repository.dart';
import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:{{project_name}}/features/auth/models/profile_model.dart';
import 'package:{{project_name}}/utils/constants/strings.dart';
import 'package:{{project_name}}/utils/global_state.dart';
import 'package:{{project_name}}/utils/my_cm.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
    : _repository = repository,
      super(AuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<UserDetailEvent>(_onUserDetailEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    // Validation Logic
    final email = event.email.trim();
    if (email.isEmpty) {
      showToast(MyStrings.enterEmail);
      return;
    }

    if (!RegExp(RegexPatterns.emailPattern).hasMatch(email)) {
      showToast(MyStrings.enterValidEmail);
      return;
    }

    if (event.password.isEmpty) {
      showToast(MyStrings.eneterPassword);
      return;
    }

    emit(state.copyWith(loginCallState: ApiCallState.busy));

    final result = await _repository.login(email, event.password);

    result.when(
      success: (LoginResponseModel loginResponse) async {
        if (loginResponse.success ?? false) {
          emit(
            state.copyWith(
              loginCallState: ApiCallState.success,
              loginModel: loginResponse,
            ),
          );
        } else {
          showToast(loginResponse.message ?? MyStrings.somethingWentWrong);
          emit(
            state.copyWith(
              loginCallState: ApiCallState.failure,
              loginErrorMessage: loginResponse.message,
            ),
          );
        }
      },
      failure: (failure) {
        emit(
          state.copyWith(
            loginCallState: ApiCallState.failure,
            loginErrorMessage: failure.toString(),
          ),
        );
      },
    );
  }

  void _onUserDetailEvent(
    UserDetailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(userDetailCallState: ApiCallState.busy));

    final result = await _repository.getUserDetail();

    result.when(
      success: (ProfileModel response) {
        String roleValue = response.data?.roleName ?? "Employee";
        String departmentValue = response.data?.departmentName ?? "UI Designer";

        emit(
          state.copyWith(
            userDetailCallState: ApiCallState.success,
            profileModel: response,
            isLocalDataLoaded: true,
            roleValue: roleValue,
            departmentValue: departmentValue,
          ),
        );

        emit(state.copyWith(userDetailCallState: ApiCallState.none));

        globalState.profileData = response.data;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            userDetailCallState: ApiCallState.failure,
            userDetailErrorMessage: failure.toString(),
          ),
        );
      },
    );
  }

  void _onUpdateProfileEvent(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.firstName.trim().isEmpty) {
      showToast(MyStrings.enterFirstName);
      return;
    }

    if (event.lastName.trim().isEmpty) {
      showToast(MyStrings.enterLastName);
      return;
    }

    if (event.phone.trim().isEmpty) {
      showToast(MyStrings.enterPhoneNumber);
      return;
    }

    emit(state.copyWith(updateProfileCallState: ApiCallState.busy));

    final result = await _repository.updateProfile(
      event.firstName,
      event.lastName,
      event.phone,
      event.image,
      event.isRemoveProfile,
    );

    if (result.success ?? false) {
      emit(
        state.copyWith(
          updateProfileCallState: ApiCallState.success,
          updateProfileResponse: result,
        ),
      );
      emit(state.copyWith(updateProfileCallState: ApiCallState.none));
    } else {
      showToast(result.message ?? MyStrings.somethingWentWrong);
      emit(
        state.copyWith(
          updateProfileCallState: ApiCallState.failure,
          updateProfileErrorMessage: result.message,
        ),
      );
    }
  }
}
