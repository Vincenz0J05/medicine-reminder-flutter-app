import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medication_reminder_app/screens/home_screen.dart';
import 'package:medication_reminder_app/services/notification_serivce.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Medicine Reminder',
        channelDescription:
            'notifications to remind users of medication intake')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Reminder Group')
  ]);
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceiveMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationsDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );
    super.initState();
    NotificationService().scheduleNotificationsBasedOnMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
