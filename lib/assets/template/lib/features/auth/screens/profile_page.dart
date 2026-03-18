import 'package:{{project_name}}/components/app_bars/appbar_with_back_and_action.dart';
import 'package:{{project_name}}/components/custome_widget_class/label_textfiled.dart';
import 'package:{{project_name}}/components/shimmer/profile_shimmer.dart';
import 'package:{{project_name}}/httpCommon/user_session_manager.dart';
import 'package:{{project_name}}/features/auth/bloc/auth_bloc.dart';
import 'package:{{project_name}}/features/auth/data/auth_datasource.dart';
import 'package:{{project_name}}/features/auth/data/auth_repository.dart';
import 'package:{{project_name}}/utils/global_state.dart';
import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthBloc _authBloc = AuthBloc(
    repository: AuthRepository(authDataSource: AuthDataSource()),
  );

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Load from storage first
    await userSessionManager.getUserData();
    _populateFormFields();
    
    // Then fetch fresh data
    _authBloc.add(UserDetailEvent());
  }

  void _populateFormFields() {
    final userData = globalState.userData;
    if (userData != null) {
      setState(() {
        _firstNameController.text = userData.firstName ?? '';
        _lastNameController.text = userData.lastName ?? '';
        _emailController.text = userData.email ?? '';
        _phoneController.text = userData.phone ?? '';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: appBarWithBackAndAction(
        strTitle: MyStrings.profile,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state.userDetailCallState == ApiCallState.success &&
              state.profileModel != null) {
            userSessionManager.saveProfileData(state.profileModel!).then((_) {
              _populateFormFields();
            });
          }

          if (state.updateProfileCallState == ApiCallState.success) {
            showToast(MyStrings.profileUpdatedSuccess);
            _authBloc.add(UserDetailEvent());
          } else if (state.updateProfileCallState == ApiCallState.failure) {
            showToast(state.updateProfileErrorMessage ?? MyStrings.profileUpdateFailed);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, state) {
            if (!state.isLocalDataLoaded && state.userDetailCallState == ApiCallState.busy) {
              return const ProfileShimmer();
            }

            final isLoading = state.updateProfileCallState == ApiCallState.busy;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelTextField(
                    MyStrings.firstName,
                    MyStrings.enterFirstNameHint,
                    _firstNameController,
                    TextInputType.name,
                    false,
                    isBorder: true,
                  ),
                  SizedBox(height: s.s20),
                  LabelTextField(
                    MyStrings.lastName,
                    MyStrings.enterLastNameHint,
                    _lastNameController,
                    TextInputType.name,
                    false,
                    isBorder: true,
                  ),
                  SizedBox(height: s.s20),
                  LabelTextField(
                    MyStrings.email,
                    MyStrings.emailHint,
                    _emailController,
                    TextInputType.emailAddress,
                    false,
                    isEnable: false,
                    isBorder: true,
                  ),
                  SizedBox(height: s.s20),
                  LabelTextField(
                    MyStrings.phoneNumber,
                    MyStrings.enterPhoneNumberHint,
                    _phoneController,
                    TextInputType.phone,
                    false,
                    isBorder: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: s.s20),
                  LabelTextField(
                    MyStrings.role,
                    MyStrings.role,
                    TextEditingController(text: state.roleValue),
                    TextInputType.text,
                    false,
                    isEnable: false,
                    isBorder: true,
                    suffixWidget: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: s.s20),
                  LabelTextField(
                    MyStrings.department,
                    MyStrings.department,
                    TextEditingController(text: state.departmentValue),
                    TextInputType.text,
                    false,
                    isEnable: false,
                    isBorder: true,
                    suffixWidget: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: s.s30),
                  Button(
                    strTitle: MyStrings.updateProfile,
                    backgroundColor: AppColors.primaryColor,
                    fontColor: Colors.white,
                    isLoading: isLoading,
                    ontap: () {
                      _authBloc.add(UpdateProfileEvent(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        image: '',
                      ));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
