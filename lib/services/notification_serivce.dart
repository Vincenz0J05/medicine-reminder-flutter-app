import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:medication_reminder_app/models/medicine.dart';

// Notification service class for managing and scheduling notifications.
class NotificationService {
  // Firestore instance for fetching medication data.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Variable to keep track of notification IDs.
  int _notificationId = 0;

  // Constructor to initialize time zones for scheduling.
  NotificationService() {
    tz.initializeTimeZones();
  }

  // Method to handle events when a notification is created.
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  // Method to handle events when a notification is displayed.
  @pragma('vm:entry-point')
  static Future<void> onNotificationsDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  // Method to handle events when a notification dismiss action is received.
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  // Method to handle events when a user taps on a notification or action button.
  @pragma('vm:entry-point')
  static Future<void> onActionReceiveMethod(
      ReceivedAction receivedAction) async {}

  // Method to schedule notifications based on the medicine data.
  Future<void> scheduleNotificationsBasedOnMedicine() async {
    // Set the timezone location for scheduling.
    final location = tz.getLocation('Europe/Amsterdam');

    // Fetch all medicines from Firestore.
    QuerySnapshot querySnapshot = await _firestore.collection('medicine').get();

    for (var doc in querySnapshot.docs) {
      Medicine medicine = Medicine.fromFirestore(doc);

      // Loop through each reminder time for the medicine.
      for (var reminderTimestamp in medicine.reminderTime) {
        DateTime utcScheduledTime = reminderTimestamp.toDate();
        tz.TZDateTime scheduledTime =
            tz.TZDateTime.from(utcScheduledTime, location);

        // Schedule the notification.
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: _notificationId++, // Incrementing ID for each notification.
            channelKey: 'basic_channel',
            title: 'Medicijne Herinnering', // Title for the notification.
            body: '${medicine.dosage} ${medicine.name} innemen.', // Body text for the notification.
          ),
          schedule: NotificationCalendar.fromDate(date: scheduledTime), // Scheduling details.
        );
      }
    }
  }
}
