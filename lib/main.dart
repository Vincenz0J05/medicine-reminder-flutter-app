import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medication_reminder_app/screens/home_screen.dart';
import 'package:medication_reminder_app/services/notification_serivce.dart';

// Entry point of the Flutter application.
Future<void> main() async {
  // Ensures that widget binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializes Firebase for the application.
  await Firebase.initializeApp();
  
  // Initializes Awesome Notifications with a basic notification channel.
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Medicine Reminder',
        channelDescription:
            'Notifications to remind users of medication intake')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Reminder Group')
  ]);
  
  // Checks if the app is allowed to send notifications and requests permission if not.
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  
  // Runs the Flutter application.
  runApp(const MyApp());
}

// MyApp is a StatefulWidget that represents the root of the application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

// State class for MyApp.
class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    // Sets listeners for different notification events.
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceiveMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationsDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );
    
    // Schedule notifications based on the user's medicine intake schedule.
    NotificationService().scheduleNotificationsBasedOnMedicine();
  }

  @override
  Widget build(BuildContext context) {
    // Defines the UI of the app, starting with HomeScreen as the home page.
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
