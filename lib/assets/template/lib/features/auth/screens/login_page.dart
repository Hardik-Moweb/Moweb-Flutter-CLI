import 'package:flutter/cupertino.dart';
import 'package:{{project_name}}/components/custome_widget_class/label_textfiled.dart';
import 'package:{{project_name}}/httpCommon/user_session_manager.dart';
import 'package:{{project_name}}/features/auth/bloc/auth_bloc.dart';
import 'package:{{project_name}}/features/auth/data/auth_datasource.dart';
import 'package:{{project_name}}/features/auth/data/auth_repository.dart';
import 'package:{{project_name}}/features/auth/screens/profile_page.dart';
import 'package:{{project_name}}/utils/import.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _authBloc = AuthBloc(
    repository: AuthRepository(authDataSource: AuthDataSource()),
  );
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  bool isObsecure = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (w, e) {
        exitApp();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) async {
            if (state.loginCallState == ApiCallState.success) {
              userSessionManager.saveLoginData(state.loginModel!);
              callNextScreen(context, const ProfilePage());
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (context, state) {
              return myBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget myBody(AuthState state) {
    return Padding(
      padding: EdgeInsets.all(s.s16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sb(s.s100),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Icon(Icons.flutter_dash),
            ),
            sb(s.s25),
            TitleTextView(
              MyStrings.welcomeBack,
              fontSize: FontSize.s24,
              fontWeight: MyFontWeights.semiBold,
            ),
            sb(s.s10),
            TitleTextView(
              MyStrings.pleaseEnterCradentials,
              fontSize: FontSize.s14,
              color: textColor,
            ),
            sb(s.s30),
            LabelTextField(
              MyStrings.email,
              MyStrings.typeHere,
              _txtEmail,
              TextInputType.emailAddress,
              false,
              isBorder: true,
              isOptional: false,
              action: TextInputAction.next,
            ),
            sb(s.s20),
            LabelTextField(
              MyStrings.password,
              MyStrings.typeHere,
              _txtPassword,
              TextInputType.text,
              false,
              isPassword: true,
              isOptional: false,
              isObsecure: !isObsecure,
              onPasswordShow: () {
                setState(() {
                  isObsecure = !isObsecure;
                });
              },
              isBorder: true,
              action: TextInputAction.done,
            ),
            sb(s.s30),
            Button(
              strTitle: MyStrings.signin,
              isLoading: state.loginCallState == ApiCallState.busy,
              fontWeight: MyFontWeights.semiBold,
              ontap: () {
                _authBloc.add(
                  LoginEvent(
                    email: _txtEmail.text.trim(),
                    password: _txtPassword.text,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
