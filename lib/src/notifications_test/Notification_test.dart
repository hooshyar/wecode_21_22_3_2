import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wecode_2021/main.dart';
import 'package:wecode_2021/src/notifications_test/second_page.dart';
import 'package:device_info/device_info.dart';
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

class PushNotificationScreenTest extends StatefulWidget {
  PushNotificationScreenTest({Key? key, this.notificationAppLaunchDetails})
      : super(key: key);

  static const String routeName = '/';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  State<PushNotificationScreenTest> createState() =>
      _PushNotificationScreenTestState();
}

class _PushNotificationScreenTestState
    extends State<PushNotificationScreenTest> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, '/secondPage');
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                          'Tap on a notification when it appears to trigger'
                          ' navigation'),
                    ),
                    InfoValueString(
                      title: 'Did notification launch app?',
                      value: widget.didNotificationLaunchApp,
                    ),
                    if (widget.didNotificationLaunchApp)
                      InfoValueString(
                        title: 'Launch notification payload:',
                        value: widget.notificationAppLaunchDetails!.payload,
                      ),
                    PaddedElevatedButton(
                      buttonText: 'Show plain notification with payload',
                      onPressed: () async {
                        await _showNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText:
                          'Show plain notification that has no title with '
                          'payload',
                      onPressed: () async {
                        await _showNotificationWithNoTitle();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText:
                          'Show plain notification that has no body with '
                          'payload',
                      onPressed: () async {
                        await _showNotificationWithNoBody();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom sound',
                      onPressed: () async {
                        await _showNotificationCustomSound();
                      },
                    ),
                    if (kIsWeb || !Platform.isLinux) ...<Widget>[
                      PaddedElevatedButton(
                        buttonText:
                            'Schedule notification to appear in 5 seconds '
                            'based on local time zone',
                        onPressed: () async {
                          await _zonedScheduleNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Repeat notification every minute',
                        onPressed: () async {
                          await _repeatNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Schedule daily 10:00:00 am notification in your '
                            'local time zone',
                        onPressed: () async {
                          await _scheduleDailyTenAMNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Schedule daily 10:00:00 am notification in your '
                            "local time zone using last year's date",
                        onPressed: () async {
                          await _scheduleDailyTenAMLastYearNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Schedule weekly 10:00:00 am notification in your '
                            'local time zone',
                        onPressed: () async {
                          await _scheduleWeeklyTenAMNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Schedule weekly Monday 10:00:00 am notification '
                            'in your local time zone',
                        onPressed: () async {
                          await _scheduleWeeklyMondayTenAMNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Check pending notifications',
                        onPressed: () async {
                          await _checkPendingNotificationRequests(context);
                        },
                      ),
                    ],
                    PaddedElevatedButton(
                      buttonText:
                          'Schedule monthly Monday 10:00:00 am notification in '
                          'your local time zone',
                      onPressed: () async {
                        await _scheduleMonthlyMondayTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText:
                          'Schedule yearly Monday 10:00:00 am notification in '
                          'your local time zone',
                      onPressed: () async {
                        await _scheduleYearlyMondayTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with no sound',
                      onPressed: () async {
                        await _showNotificationWithNoSound();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Cancel notification',
                      onPressed: () async {
                        await _cancelNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Cancel all notifications',
                      onPressed: () async {
                        await _cancelAllNotifications();
                      },
                    ),
                    if (!kIsWeb && Platform.isAndroid) ...<Widget>[
                      const Text(
                        'Android-specific examples',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Check if notifications are enabled for this app',
                        onPressed: () =>
                            _areNotifcationsEnabledOnAndroid(context),
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show plain notification with payload and update '
                            'channel description',
                        onPressed: () async {
                          await _showNotificationUpdateChannelDescription(
                              context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show plain notification as public on every '
                            'lockscreen',
                        onPressed: () async {
                          await _showPublicNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show notification with custom vibration pattern, '
                            'red LED and red icon',
                        onPressed: () async {
                          await _showNotificationCustomVibrationIconLed(
                              context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification using Android Uri sound',
                        onPressed: () async {
                          await _showSoundUriNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show notification that times out after 3 seconds',
                        onPressed: () async {
                          await _showTimeoutNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show insistent notification',
                        onPressed: () async {
                          await _showInsistentNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show big picture notification using local images',
                        onPressed: () async {
                          await _showBigPictureNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show big picture notification using base64 String '
                            'for images',
                        onPressed: () async {
                          await _showBigPictureNotificationBase64(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show big picture notification using URLs for '
                            'Images',
                        onPressed: () async {
                          await _showBigPictureNotificationURL(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show big picture notification, hide large icon '
                            'on expand',
                        onPressed: () async {
                          await _showBigPictureNotificationHiddenLargeIcon(
                              context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show media notification',
                        onPressed: () async {
                          await _showNotificationMediaStyle(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show big text notification',
                        onPressed: () async {
                          await _showBigTextNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show inbox notification',
                        onPressed: () async {
                          await _showInboxNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show messaging notification',
                        onPressed: () async {
                          await _showMessagingNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show grouped notifications',
                        onPressed: () async {
                          await _showGroupedNotifications(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with tag',
                        onPressed: () async {
                          await _showNotificationWithTag(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Cancel notification with tag',
                        onPressed: () async {
                          await _cancelNotificationWithTag(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show ongoing notification',
                        onPressed: () async {
                          await _showOngoingNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show notification with no badge, alert only once',
                        onPressed: () async {
                          await _showNotificationWithNoBadge(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Show progress notification - updates every second',
                        onPressed: () async {
                          await _showProgressNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show indeterminate progress notification',
                        onPressed: () async {
                          await _showIndeterminateProgressNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification without timestamp',
                        onPressed: () async {
                          await _showNotificationWithoutTimestamp(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with custom timestamp',
                        onPressed: () async {
                          await _showNotificationWithCustomTimestamp(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with custom sub-text',
                        onPressed: () async {
                          await _showNotificationWithCustomSubText(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with chronometer',
                        onPressed: () async {
                          await _showNotificationWithChronometer(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show full-screen notification',
                        onPressed: () async {
                          await _showFullScreenNotification(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Create grouped notification channels',
                        onPressed: () async {
                          await _createNotificationChannelGroup(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Delete notification channel group',
                        onPressed: () async {
                          await _deleteNotificationChannelGroup(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Create notification channel',
                        onPressed: () async {
                          await _createNotificationChannel(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Delete notification channel',
                        onPressed: () async {
                          await _deleteNotificationChannel(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Get notification channels',
                        onPressed: () async {
                          await _getNotificationChannels(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Get active notifications',
                        onPressed: () async {
                          await _getActiveNotifications(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Start foreground service',
                        onPressed: () async {
                          await _startForegroundService(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText:
                            'Start foreground service with blue background notification',
                        onPressed: () async {
                          await _startForegroundServiceWithBlueBackgroundNotification(
                              context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Stop foreground service',
                        onPressed: () async {
                          await _stopForegroundService(context);
                        },
                      ),
                    ],
                    if (!kIsWeb &&
                        (Platform.isIOS || Platform.isMacOS)) ...<Widget>[
                      const Text(
                        'iOS and macOS-specific examples',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with subtitle',
                        onPressed: () async {
                          await _showNotificationWithSubtitle(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with icon badge',
                        onPressed: () async {
                          await _showNotificationWithIconBadge(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with attachment',
                        onPressed: () async {
                          await _showNotificationWithAttachment(context);
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notifications with thread identifier',
                        onPressed: () async {
                          await _showNotificationsWithThreadIdentifier(context);
                        },
                      ),
                    ],
                    if (!kIsWeb && Platform.isLinux) ...<Widget>[
                      const Text(
                        'Linux-specific examples',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<LinuxServerCapabilities>(
                        future: getLinuxCapabilities(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<LinuxServerCapabilities> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            final LinuxServerCapabilities caps = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Capabilities of the current system:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  InfoValueString(
                                    title: 'Body text:',
                                    value: caps.body,
                                  ),
                                  InfoValueString(
                                    title: 'Hyperlinks in body text:',
                                    value: caps.bodyHyperlinks,
                                  ),
                                  InfoValueString(
                                    title: 'Images in body:',
                                    value: caps.bodyImages,
                                  ),
                                  InfoValueString(
                                    title: 'Markup in the body text:',
                                    value: caps.bodyMarkup,
                                  ),
                                  InfoValueString(
                                    title: 'Animated icons:',
                                    value: caps.iconMulti,
                                  ),
                                  InfoValueString(
                                    title: 'Static icons:',
                                    value: caps.iconStatic,
                                  ),
                                  InfoValueString(
                                    title: 'Notification persistence:',
                                    value: caps.persistence,
                                  ),
                                  InfoValueString(
                                    title: 'Sound:',
                                    value: caps.sound,
                                  ),
                                  InfoValueString(
                                    title: 'Other capabilities:',
                                    value: caps.otherCapabilities,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with body markup',
                        onPressed: () async {
                          await _showLinuxNotificationWithBodyMarkup();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with category',
                        onPressed: () async {
                          await _showLinuxNotificationWithCategory();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with byte data icon',
                        onPressed: () async {
                          await _showLinuxNotificationWithByteDataIcon();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with theme icon',
                        onPressed: () async {
                          await _showLinuxNotificationWithThemeIcon();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with theme sound',
                        onPressed: () async {
                          await _showLinuxNotificationWithThemeSound();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with critical urgency',
                        onPressed: () async {
                          await _showLinuxNotificationWithCriticalUrgency();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with timeout',
                        onPressed: () async {
                          await _showLinuxNotificationWithTimeout();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Suppress notification sound',
                        onPressed: () async {
                          await _showLinuxNotificationSuppressSound();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Transient notification',
                        onPressed: () async {
                          await _showLinuxNotificationTransient();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Resident notification',
                        onPressed: () async {
                          await _showLinuxNotificationResident();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification on '
                            'different screen location',
                        onPressed: () async {
                          await _showLinuxNotificationDifferentLocation();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showFullScreenNotification(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Turn off your screen'),
      content: const Text(
          'to see the full-screen intent in 5 seconds, press OK and TURN '
          'OFF your screen'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await flutterLocalNotificationsPlugin.zonedSchedule(
                0,
                'scheduled title',
                'scheduled body',
                tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                const NotificationDetails(
                    android: AndroidNotificationDetails(
                        'full screen channel id', 'full screen channel name',
                        channelDescription: 'full screen channel description',
                        priority: Priority.high,
                        importance: Importance.high,
                        fullScreenIntent: true)),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime);

            Navigator.pop(context);
          },
          child: const Text('OK'),
        )
      ],
    ),
  );
}

Future<void> _showNotificationWithNoBody() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', null, platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithNoTitle() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin
      .show(0, null, 'plain body', platformChannelSpecifics, payload: 'item x');
}

Future<void> _cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

Future<void> _cancelNotificationWithTag(BuildContext context) async {
  await flutterLocalNotificationsPlugin.cancel(0, tag: 'tag');
}

Future<void> _showNotificationCustomSound() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    channelDescription: 'your other channel description',
    sound: RawResourceAndroidNotificationSound('slow_spring_board'),
  );
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: 'slow_spring_board.aiff');
  const MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    sound: AssetsLinuxSound('sound/slow_spring_board.mp3'),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
    macOS: macOSPlatformChannelSpecifics,
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'custom sound notification title',
    'custom sound notification body',
    platformChannelSpecifics,
  );
}

Future<void> _showNotificationCustomVibrationIconLed(
    BuildContext context) async {
  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'other custom channel id', 'other custom channel name',
          channelDescription: 'other custom channel description',
          icon: 'secondary_icon',
          largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
          vibrationPattern: vibrationPattern,
          enableLights: true,
          color: const Color.fromARGB(255, 255, 0, 0),
          ledColor: const Color.fromARGB(255, 255, 0, 0),
          ledOnMs: 1000,
          ledOffMs: 500);

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'title of notification with custom vibration pattern, LED and icon',
      'body of notification with custom vibration pattern, LED and icon',
      platformChannelSpecifics);
}

Future<void> _zonedScheduleNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> _showNotificationWithNoSound() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('silent channel id', 'silent channel name',
          channelDescription: 'silent channel description',
          playSound: false,
          styleInformation: DefaultStyleInformation(true, true));
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(presentSound: false);
  const MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(presentSound: false);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, '<b>silent</b> title', '<b>silent</b> body', platformChannelSpecifics);
}

Future<void> _showSoundUriNotification(BuildContext context) async {
  /// this calls a method over a platform channel implemented within the
  /// example app to return the Uri for the default alarm sound and uses
  /// as the notification sound
  final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
  final UriAndroidNotificationSound uriSound =
      UriAndroidNotificationSound(alarmUri!);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('uri channel id', 'uri channel name',
          channelDescription: 'uri channel description',
          sound: uriSound,
          styleInformation: const DefaultStyleInformation(true, true));
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'uri sound title', 'uri sound body', platformChannelSpecifics);
}

Future<void> _showTimeoutNotification(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('silent channel id', 'silent channel name',
          channelDescription: 'silent channel description',
          timeoutAfter: 3000,
          styleInformation: DefaultStyleInformation(true, true));
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
      'Times out after 3 seconds', platformChannelSpecifics);
}

Future<void> _showInsistentNotification(BuildContext context) async {
  // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
  const int insistentFlag = 4;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          additionalFlags: Int32List.fromList(<int>[insistentFlag]));
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'insistent title', 'insistent body', platformChannelSpecifics,
      payload: 'item x');
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> _showBigPictureNotification(BuildContext context) async {
  final String largeIconPath = await _downloadAndSaveFile(
      'https://via.placeholder.com/48x48', 'largeIcon');
  final String bigPicturePath = await _downloadAndSaveFile(
      'https://via.placeholder.com/400x800', 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          contentTitle: 'overridden <b>big</b> content title',
          htmlFormatContentTitle: true,
          summaryText: 'summary <i>text</i>',
          htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('big text channel id', 'big text channel name',
          channelDescription: 'big text channel description',
          styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<String> _base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}

Future<void> _showBigPictureNotificationBase64(BuildContext context) async {
  final String largeIcon =
      await _base64encodedImage('https://via.placeholder.com/48x48');
  final String bigPicture =
      await _base64encodedImage('https://via.placeholder.com/400x800');

  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(
              bigPicture), //Base64AndroidBitmap(bigPicture),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
          contentTitle: 'overridden <b>big</b> content title',
          htmlFormatContentTitle: true,
          summaryText: 'summary <i>text</i>',
          htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('big text channel id', 'big text channel name',
          channelDescription: 'big text channel description',
          styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

Future<void> _showBigPictureNotificationURL(BuildContext context) async {
  final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl('https://via.placeholder.com/48x48'));
  final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl('https://via.placeholder.com/400x800'));

  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(bigPicture,
          largeIcon: largeIcon,
          contentTitle: 'overridden <b>big</b> content title',
          htmlFormatContentTitle: true,
          summaryText: 'summary <i>text</i>',
          htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('big text channel id', 'big text channel name',
          channelDescription: 'big text channel description',
          styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<void> _showBigPictureNotificationHiddenLargeIcon(
    BuildContext context) async {
  final String largeIconPath = await _downloadAndSaveFile(
      'https://via.placeholder.com/48x48', 'largeIcon');
  final String bigPicturePath = await _downloadAndSaveFile(
      'https://via.placeholder.com/400x800', 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: 'overridden <b>big</b> content title',
          htmlFormatContentTitle: true,
          summaryText: 'summary <i>text</i>',
          htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('big text channel id', 'big text channel name',
          channelDescription: 'big text channel description',
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: bigPictureStyleInformation);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<void> _showNotificationMediaStyle(BuildContext context) async {
  final String largeIconPath = await _downloadAndSaveFile(
      'https://via.placeholder.com/128x128/00FF00/000000', 'largeIcon');
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'media channel id',
    'media channel name',
    channelDescription: 'media channel description',
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: const MediaStyleInformation(),
  );
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'notification title', 'notification body', platformChannelSpecifics);
}

Future<void> _showBigTextNotification(BuildContext context) async {
  const BigTextStyleInformation bigTextStyleInformation =
      BigTextStyleInformation(
    'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    htmlFormatBigText: true,
    contentTitle: 'overridden <b>big</b> content title',
    htmlFormatContentTitle: true,
    summaryText: 'summary <i>text</i>',
    htmlFormatSummaryText: true,
  );
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('big text channel id', 'big text channel name',
          channelDescription: 'big text channel description',
          styleInformation: bigTextStyleInformation);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<void> _showInboxNotification(BuildContext context) async {
  final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
  final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      lines,
      htmlFormatLines: true,
      contentTitle: 'overridden <b>inbox</b> context title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
          channelDescription: 'inbox channel description',
          styleInformation: inboxStyleInformation);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'inbox title', 'inbox body', platformChannelSpecifics);
}

Future<void> _showMessagingNotification(BuildContext context) async {
  // use a platform channel to resolve an Android drawable resource to a URI.
  // This is NOT part of the notifications plugin. Calls made over this
  /// channel is handled by the app
  final String? imageUri = await platform.invokeMethod('drawableToUri', 'food');

  /// First two person objects will use icons that part of the Android app's
  /// drawable resources
  const Person me = Person(
    name: 'Me',
    key: '1',
    uri: 'tel:1234567890',
    icon: DrawableResourceAndroidIcon('me'),
  );
  const Person coworker = Person(
    name: 'Coworker',
    key: '2',
    uri: 'tel:9876543210',
    icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  );
  // download the icon that would be use for the lunch bot person
  final String largeIconPath = await _downloadAndSaveFile(
      'https://via.placeholder.com/48x48', 'largeIcon');
  // this person object will use an icon that was downloaded
  final Person lunchBot = Person(
    name: 'Lunch bot',
    key: 'bot',
    bot: true,
    icon: BitmapFilePathAndroidIcon(largeIconPath),
  );
  final Person chef = Person(
      name: 'Master Chef',
      key: '3',
      uri: 'tel:111222333444',
      icon: ByteArrayAndroidIcon.fromBase64String(
          await _base64encodedImage('https://placekitten.com/48/48')));

  final List<Message> messages = <Message>[
    Message('Hi', DateTime.now(), null),
    Message(
        "What's up?", DateTime.now().add(const Duration(minutes: 5)), coworker),
    Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
        dataMimeType: 'image/png', dataUri: imageUri),
    Message('What kind of food would you prefer?',
        DateTime.now().add(const Duration(minutes: 10)), lunchBot),
    Message('You do not have time eat! Keep working!',
        DateTime.now().add(const Duration(minutes: 11)), chef),
  ];
  final MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
      groupConversation: true,
      conversationTitle: 'Team lunch',
      htmlFormatContent: true,
      htmlFormatTitle: true,
      messages: messages);
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('message channel id', 'message channel name',
          channelDescription: 'message channel description',
          category: 'msg',
          styleInformation: messagingStyle);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'message title', 'message body', platformChannelSpecifics);

  // wait 10 seconds and add another message to simulate another response
  await Future<void>.delayed(const Duration(seconds: 10), () async {
    messages.add(Message("I'm so sorry!!! But I really like thai food ...",
        DateTime.now().add(const Duration(minutes: 11)), null));
    await flutterLocalNotificationsPlugin.show(
        0, 'message title', 'message body', platformChannelSpecifics);
  });
}

Future<void> _showGroupedNotifications(BuildContext context) async {
  const String groupKey = 'com.android.example.WORK_EMAIL';
  const String groupChannelId = 'grouped channel id';
  const String groupChannelName = 'grouped channel name';
  const String groupChannelDescription = 'grouped channel description';
  // example based on https://developer.android.com/training/notify-user/group.html
  const AndroidNotificationDetails firstNotificationAndroidSpecifics =
      AndroidNotificationDetails(groupChannelId, groupChannelName,
          channelDescription: groupChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          groupKey: groupKey);
  const NotificationDetails firstNotificationPlatformSpecifics =
      NotificationDetails(android: firstNotificationAndroidSpecifics);
  await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
      'You will not believe...', firstNotificationPlatformSpecifics);
  const AndroidNotificationDetails secondNotificationAndroidSpecifics =
      AndroidNotificationDetails(groupChannelId, groupChannelName,
          channelDescription: groupChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          groupKey: groupKey);
  const NotificationDetails secondNotificationPlatformSpecifics =
      NotificationDetails(android: secondNotificationAndroidSpecifics);
  await flutterLocalNotificationsPlugin.show(
      2,
      'Jeff Chang',
      'Please join us to celebrate the...',
      secondNotificationPlatformSpecifics);

  // Create the summary notification to support older devices that pre-date
  /// Android 7.0 (API level 24).
  ///
  /// Recommended to create this regardless as the behaviour may vary as
  /// mentioned in https://developer.android.com/training/notify-user/group
  const List<String> lines = <String>[
    'Alex Faarborg  Check this out',
    'Jeff Chang    Launch Party'
  ];
  const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      lines,
      contentTitle: '2 messages',
      summaryText: 'janedoe@example.com');
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(groupChannelId, groupChannelName,
          channelDescription: groupChannelDescription,
          styleInformation: inboxStyleInformation,
          groupKey: groupKey,
          setAsGroupSummary: true);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      3, 'Attention', 'Two messages', platformChannelSpecifics);
}

Future<void> _showNotificationWithTag(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          tag: 'tag');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
      0, 'first notification', null, platformChannelSpecifics);
}

Future<void> _checkPendingNotificationRequests(BuildContext context) async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content:
          Text('${pendingNotificationRequests.length} pending notification '
              'requests'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> _cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _showOngoingNotification(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
      'ongoing notification body', platformChannelSpecifics);
}

Future<void> _repeatNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'repeating channel id', 'repeating channel name',
          channelDescription: 'repeating description');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
      'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
      androidAllowWhileIdle: true);
}

Future<void> _scheduleDailyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

/// To test we don't validate past dates when using `matchDateTimeComponents`
Future<void> _scheduleDailyTenAMLastYearNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      _nextInstanceOfTenAMLastYear(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> _scheduleWeeklyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('weekly notification channel id',
            'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> _scheduleWeeklyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('weekly notification channel id',
            'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> _scheduleMonthlyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'monthly scheduled notification title',
      'monthly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('monthly notification channel id',
            'monthly notification channel name',
            channelDescription: 'monthly notificationdescription'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
}

Future<void> _scheduleYearlyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'yearly scheduled notification title',
      'yearly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('yearly notification channel id',
            'yearly notification channel name',
            channelDescription: 'yearly notification description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime);
}

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfTenAMLastYear() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  return tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10);
}

tz.TZDateTime _nextInstanceOfMondayTenAM() {
  tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  while (scheduledDate.weekday != DateTime.monday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> _showNotificationWithNoBadge(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('no badge channel', 'no badge name',
          channelDescription: 'no badge description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'no badge title', 'no badge body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showProgressNotification(BuildContext context) async {
  const int maxProgress = 5;
  for (int i = 0; i <= maxProgress; i++) {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('progress channel', 'progress channel',
              channelDescription: 'progress channel description',
              channelShowBadge: false,
              importance: Importance.max,
              priority: Priority.high,
              onlyAlertOnce: true,
              showProgress: true,
              maxProgress: maxProgress,
              progress: i);
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'progress notification title',
          'progress notification body',
          platformChannelSpecifics,
          payload: 'item x');
    });
  }
}

Future<void> _showIndeterminateProgressNotification(
    BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'indeterminate progress channel', 'indeterminate progress channel',
          channelDescription: 'indeterminate progress channel description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          indeterminate: true);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'indeterminate progress notification title',
      'indeterminate progress notification body',
      platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationUpdateChannelDescription(
    BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your updated channel description',
          importance: Importance.max,
          priority: Priority.high,
          channelAction: AndroidNotificationChannelAction.update);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'updated notification channel',
      'check settings to see updated channel description',
      platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showPublicNotification(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          visibility: NotificationVisibility.public);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'public notification title',
      'public notification body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithSubtitle(BuildContext context) async {
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(subtitle: 'the subtitle');
  const MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(subtitle: 'the subtitle');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'title of notification with a subtitle',
      'body of notification with a subtitle',
      platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithIconBadge(BuildContext context) async {
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(badgeNumber: 1);
  const MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(badgeNumber: 1);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationsWithThreadIdentifier(
    BuildContext context) async {
  NotificationDetails buildNotificationDetailsForThread(
    String threadIdentifier,
  ) {
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(threadIdentifier: threadIdentifier);
    final MacOSNotificationDetails macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(threadIdentifier: threadIdentifier);
    return NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
  }

  final NotificationDetails thread1PlatformChannelSpecifics =
      buildNotificationDetailsForThread('thread1');
  final NotificationDetails thread2PlatformChannelSpecifics =
      buildNotificationDetailsForThread('thread2');

  await flutterLocalNotificationsPlugin.show(
      0, 'thread 1', 'first notification', thread1PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      1, 'thread 1', 'second notification', thread1PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      2, 'thread 1', 'third notification', thread1PlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      3, 'thread 2', 'first notification', thread2PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      4, 'thread 2', 'second notification', thread2PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      5, 'thread 2', 'third notification', thread2PlatformChannelSpecifics);
}

Future<void> _showNotificationWithoutTimestamp(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithCustomTimestamp(BuildContext context) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
  );
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithCustomSubText(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    subText: 'custom subtext',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithChronometer(BuildContext context) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    usesChronometer: true,
  );
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotificationWithAttachment(BuildContext context) async {
  final String bigPicturePath = await _downloadAndSaveFile(
      'https://via.placeholder.com/600x200', 'bigPicture.jpg');
  final IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(attachments: <IOSNotificationAttachment>[
    IOSNotificationAttachment(bigPicturePath)
  ]);
  final MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(attachments: <MacOSNotificationAttachment>[
    MacOSNotificationAttachment(bigPicturePath)
  ]);
  final NotificationDetails notificationDetails = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'notification with attachment title',
      'notification with attachment body',
      notificationDetails);
}

Future<void> _createNotificationChannelGroup(BuildContext context) async {
  const String channelGroupId = 'your channel group id';
  // create the group first
  const AndroidNotificationChannelGroup androidNotificationChannelGroup =
      AndroidNotificationChannelGroup(channelGroupId, 'your channel group name',
          description: 'your channel group description');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannelGroup(androidNotificationChannelGroup);

  // create channels associated with the group
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
          'grouped channel id 1', 'grouped channel name 1',
          description: 'grouped channel description 1',
          groupId: channelGroupId));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
          'grouped channel id 2', 'grouped channel name 2',
          description: 'grouped channel description 2',
          groupId: channelGroupId));

  await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: Text('Channel group with name '
                '${androidNotificationChannelGroup.name} created'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ));
}

Future<void> _deleteNotificationChannelGroup(BuildContext context) async {
  const String channelGroupId = 'your channel group id';
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.deleteNotificationChannelGroup(channelGroupId);

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: const Text('Channel group with id $channelGroupId deleted'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> _startForegroundService(BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.startForegroundService(1, 'plain title', 'plain body',
          notificationDetails: androidPlatformChannelSpecifics,
          payload: 'item x');
}

Future<void> _startForegroundServiceWithBlueBackgroundNotification(
    BuildContext context) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'color background channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Colors.blue,
    colorized: true,
  );

  /// only using foreground service can color the background
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.startForegroundService(
          1, 'colored background text title', 'colored background text body',
          notificationDetails: androidPlatformChannelSpecifics,
          payload: 'item x');
}

Future<void> _stopForegroundService(BuildContext context) async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.stopForegroundService();
}

Future<void> _createNotificationChannel(BuildContext context) async {
  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'your channel id 2',
    'your channel name 2',
    description: 'your channel description 2',
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content:
                Text('Channel with name ${androidNotificationChannel.name} '
                    'created'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ));
}

Future<void> _areNotifcationsEnabledOnAndroid(context) async {
  final bool? areEnabled = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.areNotificationsEnabled();
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: Text(areEnabled == null
                ? 'ERROR: received null'
                : (areEnabled
                    ? 'Notifications are enabled'
                    : 'Notifications are NOT enabled')),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ));
}

Future<void> _deleteNotificationChannel(BuildContext context) async {
  const String channelId = 'your channel id 2';
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.deleteNotificationChannel(channelId);

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: const Text('Channel with id $channelId deleted'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> _getActiveNotifications(BuildContext context) async {
  final Widget activeNotificationsDialogContent =
      await _getActiveNotificationsDialogContent();
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: activeNotificationsDialogContent,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<Widget> _getActiveNotificationsDialogContent() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  if (!(androidInfo.version.sdkInt >= 23)) {
    return const Text(
      '"getActiveNotifications" is available only for Android 6.0 or newer',
    );
  }

  try {
    final List<ActiveNotification>? activeNotifications =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .getActiveNotifications();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'Active Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Divider(color: Colors.black),
        if (activeNotifications!.isEmpty) const Text('No active notifications'),
        if (activeNotifications.isNotEmpty)
          for (ActiveNotification activeNotification in activeNotifications)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'id: ${activeNotification.id}\n'
                  'channelId: ${activeNotification.channelId}\n'
                  'title: ${activeNotification.title}\n'
                  'body: ${activeNotification.body}',
                ),
                const Divider(color: Colors.black),
              ],
            ),
      ],
    );
  } on PlatformException catch (error) {
    return Text(
      'Error calling "getActiveNotifications"\n'
      'code: ${error.code}\n'
      'message: ${error.message}',
    );
  }
}

Future<void> _getNotificationChannels(BuildContext context) async {
  final Widget notificationChannelsDialogContent =
      await _getNotificationChannelsDialogContent();
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: notificationChannelsDialogContent,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<Widget> _getNotificationChannelsDialogContent() async {
  try {
    final List<AndroidNotificationChannel>? channels =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .getNotificationChannels();

    return Container(
      width: double.maxFinite,
      child: ListView(
        children: <Widget>[
          const Text(
            'Notifications Channels',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (channels?.isEmpty ?? true)
            const Text('No notification channels')
          else
            for (AndroidNotificationChannel channel in channels!)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('id: ${channel.id}\n'
                      'name: ${channel.name}\n'
                      'description: ${channel.description}\n'
                      'groupId: ${channel.groupId}\n'
                      'importance: ${channel.importance.value}\n'
                      'playSound: ${channel.playSound}\n'
                      'sound: ${channel.sound?.sound}\n'
                      'enableVibration: ${channel.enableVibration}\n'
                      'vibrationPattern: ${channel.vibrationPattern}\n'
                      'showBadge: ${channel.showBadge}\n'
                      'enableLights: ${channel.enableLights}\n'
                      'ledColor: ${channel.ledColor}\n'),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      ),
    );
  } on PlatformException catch (error) {
    return Text(
      'Error calling "getNotificationChannels"\n'
      'code: ${error.code}\n'
      'message: ${error.message}',
    );
  }
}

Future<void> _showLinuxNotificationWithBodyMarkup() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with body markup',
    '<b>bold text</b>\n'
        '<i>italic text</i>\n'
        '<u>underline text</u>\n'
        'https://example.com\n'
        '<a href="https://example.com">example.com</a>',
    null,
  );
}

Future<void> _showLinuxNotificationWithCategory() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    category: LinuxNotificationCategory.emailArrived(),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with category',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationWithByteDataIcon() async {
  final ByteData assetIcon = await rootBundle.load(
    'icons/app_icon_density.png',
  );
  final image.Image? iconData = image.decodePng(
    assetIcon.buffer.asUint8List().toList(),
  );
  final Uint8List iconBytes = iconData!.getBytes();
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    icon: ByteDataLinuxIcon(
      LinuxRawIconData(
        data: iconBytes,
        width: iconData.width,
        height: iconData.height,
        channels: 4, // The icon has an alpha channel
        hasAlpha: true,
      ),
    ),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with byte data icon',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationWithThemeIcon() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    icon: ThemeLinuxIcon('media-eject'),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with theme icon',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationWithThemeSound() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    sound: ThemeLinuxSound('message-new-email'),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with theme sound',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationWithCriticalUrgency() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    urgency: LinuxNotificationUrgency.critical,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with critical urgency',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationWithTimeout() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    timeout: LinuxNotificationTimeout.fromDuration(
      const Duration(seconds: 1),
    ),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with timeout',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationSuppressSound() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    suppressSound: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'suppress notification sound',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationTransient() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    transient: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'transient notification',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationResident() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(
    resident: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'resident notification',
    null,
    platformChannelSpecifics,
  );
}

Future<void> _showLinuxNotificationDifferentLocation() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
      LinuxNotificationDetails(location: LinuxNotificationLocation(10, 10));
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification on different screen location',
    null,
    platformChannelSpecifics,
  );
}

Future<LinuxServerCapabilities> getLinuxCapabilities() =>
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            LinuxFlutterLocalNotificationsPlugin>()!
        .getCapabilities();
