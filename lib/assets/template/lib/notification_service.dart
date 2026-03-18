/*
import 'dart:async';
import 'dart:convert';

import 'package:{{project_name}}/utils/app_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:{{project_name}}/utils/import.dart';

int id = 0;

Map<int, String> notificationsMap = {};

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  printLog('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  if (message.notification != null) {
    final notification = message.notification!;
    addNotificationToMap(message.data.hashCode, jsonEncode(message.data));
    
    await flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

void addNotificationToMap(int id, String payload) {
  notificationsMap[id] = payload;
}

class NotificationServiceNew {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      AppPreference.instance.savePref(token, PreferenceKey.prefDeviceToken);
    }
    return token;
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        int id = notificationResponse.id ?? 0;
        String? payload = notificationsMap[id];

        if (payload != null) {
          _handleClickActionForNotification(jsonDecode(payload));
        } else if (notificationResponse.payload != null) {
          try {
            _handleClickActionForNotification(jsonDecode(notificationResponse.payload!));
          } catch (e) {
            printLog('Error parsing notification payload: $e');
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message, fromBackground: false);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleClickActionForNotification(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _handleClickActionForNotification(message.data);
        });
      }
    });
  }

  void _handleClickActionForNotification(Map<String, dynamic> message) {
    if (message.isEmpty) return;

    // Navigation logic removed since HomePage is gone.
    // In a full app, you might navigate to a specific notification details page.
    printLog("Notification clicked with data: $message");
  }

  Future<void> showNotification(RemoteMessage message, {bool fromBackground = false}) async {
    if (fromBackground) return;
    
    RemoteNotification? notification = message.notification;
    
    if (notification == null) {
      String? title = message.data['title'] ?? message.data['subject'];
      String? body = message.data['body'] ?? message.data['message'];
      
      if (title != null || body != null) {
        addNotificationToMap(message.data.hashCode, jsonEncode(message.data));
        await flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          title ?? 'New Notification',
          body ?? '',
          NotificationDetails(
            android: const AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
      return;
    }
    
    addNotificationToMap(message.data.hashCode, jsonEncode(message.data));
    
    await flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      notification.title ?? 'New Notification',
      notification.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

class NotiData {
  String? taskId;
  String? parentTaskId;
  String? notificationTypeId;
  String? notificationId;

  NotiData({
    this.taskId,
    this.parentTaskId,
    this.notificationTypeId,
    this.notificationId,
  });

  NotiData.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    parentTaskId = json['parent_task_id'];
    notificationTypeId = json['notification_type_id'];
    notificationId = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['parent_task_id'] = parentTaskId;
    data['notification_type_id'] = notificationTypeId;
    data['notification_id'] = notificationId;
    return data;
  }
}
*/