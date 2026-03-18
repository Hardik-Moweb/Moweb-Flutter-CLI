import 'dart:convert';

import 'package:{{project_name}}/components/version_update.dart';
import 'package:{{project_name}}/features/auth/screens/login_page.dart';
import 'package:{{project_name}}/features/auth/models/user_data_model.dart';
import 'package:{{project_name}}/utils/global_state.dart';
import 'package:{{project_name}}/utils/import.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    navigateToScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.flutter_dash)));
  }

  void navigateToScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userLogin = prefs.getBool(PreferenceKey.prefIsUserLoggedIn);

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      // Check for version updates
      final updateRequired = await checkVersion(context);

      if (!mounted) return;
      // Only navigate if no forced update is required
      if (updateRequired != true) {
        if (userLogin == true) {
          globalState.userData = UserDataModel.fromJson(
            json.decode(prefs.getString(Pref.userData) ?? ""),
          );
          globalState.updateIsSuperAdminFromUserData();

          // After login, navigate to a dashboard (using LoginPage as placeholder since others are removed)
          // You should replace this with your actual home page later
          callNextScreenAndClearStack(context, const LoginPage());
        } else {
          callNextScreenAndClearStack(context, const LoginPage());
        }
      }
    });
  }
}
