import 'package:{{project_name}}/config/flavor_config.dart';
import 'package:{{project_name}}/landing_page.dart';
import 'package:{{project_name}}/features/auth/bloc/auth_bloc.dart';
import 'package:{{project_name}}/features/auth/data/auth_datasource.dart';
import 'package:{{project_name}}/features/auth/data/auth_repository.dart';
import 'package:{{project_name}}/utils/constants/app_colors.dart';
import 'package:{{project_name}}/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name}}/utils/my_cm.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  void initState() {
    super.initState();

    // Initialize the global download manager
    // GlobalDownloadManager().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final flavor = FlavorConfig.instance.buildFlavor.name;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: flavor == "prod"
          ? materialApp()
          : Banner(
              location: BannerLocation.topStart,
              message: flavor,
              child: materialApp(),
            ),
    );
  }

  Widget materialApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            repository: AuthRepository(authDataSource: AuthDataSource()),
          ),
        ),
      ],
      child: MaterialApp(
        title: MyStrings.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalVariable.navState,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const LandingPage(),
      ),
    );
  }
}
