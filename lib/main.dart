import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode_2021/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wecode_2021/src/notifications_test/Notification_test.dart';
import 'package:wecode_2021/src/providers/nameProvider.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) => print('initialized'));

  //FIXME: initialize Local notifications
  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = '/';
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    initialRoute = '/second';
  }

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');

  // /// Note: permissions aren't requested here just to demonstrate that can be
  // /// done later
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         requestAlertPermission: false,
  //         requestBadgePermission: false,
  //         requestSoundPermission: false,
  //         onDidReceiveLocalNotification: (
  //           int id,
  //           String? title,
  //           String? body,
  //           String? payload,
  //         ) async {
  //           didReceiveLocalNotificationSubject.add(
  //             ReceivedNotification(
  //               id: id,
  //               title: title,
  //               body: body,
  //               payload: payload,
  //             ),
  //           );
  //         });
  // const MacOSInitializationSettings initializationSettingsMacOS =
  //     MacOSInitializationSettings(
  //   requestAlertPermission: false,
  //   requestBadgePermission: false,
  //   requestSoundPermission: false,
  // );
  // final LinuxInitializationSettings initializationSettingsLinux =
  //     LinuxInitializationSettings(
  //   defaultActionName: 'Open notification',
  //   defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  // );
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  //   macOS: initializationSettingsMacOS,
  //   linux: initializationSettingsLinux,
  // );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   selectedNotificationPayload = payload;
  //   selectNotificationSubject.add(payload);
  // });
  //FIXME: initialize Local notifications

  //notifications session
  // await FirebaseAuth.instance.signInAnonymously().then((userCredential) async {
  //   debugPrint('user id:' + userCredential.user!.uid);
  //   await FirebaseMessaging.instance.getToken().then((token) async {
  //     debugPrint('token: $token');
  //     await FirebaseFirestore.instance
  //         .collection('test_users')
  //         .doc(userCredential.user!.uid)
  //         .set({'uid': userCredential.user!.uid, 'token': token},
  //             SetOptions(merge: true));
  //   });
  // });
  runApp(
    MultiProvider(
      child: const AppView(),
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
