import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name}}/application_page.dart';
import 'package:{{project_name}}/config/env_service.dart';
import 'package:{{project_name}}/config/flavor_config.dart';

// import 'firebase_options.dart';
// import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initialize the flavor config and environment variables
  await FlavorConfig.initFromNative();
  await EnvService().init();

  // Initialize Firebase with platform-specific and flavor-specific options
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialize notification service
  // final notificationService = NotificationServiceNew();
  // await notificationService.init();
  // await notificationService.getToken();

  runApp(const ApplicationPage());
}
