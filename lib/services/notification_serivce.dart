import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:medication_reminder_app/models/medicine.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _notificationId = 0; // Class member to keep track of the last ID used

  NotificationService() {
    tz.initializeTimeZones();
  }
  // method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  // method to detect every time a new notification is displayed
  @pragma('vm:entry-point')
  static Future<void> onNotificationsDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  // method to detect when user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceiveMethod(
      ReceivedAction receivedAction) async {}

  Future<void> scheduleNotificationsBasedOnMedicine() async {
    final location = tz.getLocation('Europe/Amsterdam');

    // Fetch all medicines or a specific set of medicines
    QuerySnapshot querySnapshot = await _firestore.collection('medicine').get();

    for (var doc in querySnapshot.docs) {
      Medicine medicine = Medicine.fromFirestore(doc);

      // Assuming each medicine has a list of reminder times
      for (var reminderTimestamp in medicine.reminderTime) {
        DateTime utcScheduledTime = reminderTimestamp.toDate();
        tz.TZDateTime scheduledTime =
            tz.TZDateTime.from(utcScheduledTime, location);

        // Schedule the notification (removed the check for future times)
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: _notificationId++, // Unique ID for each notification
            channelKey: 'basic_channel',
            title: 'Medicijne Herinnering',
            body: '${medicine.dosage} ${medicine.name} innemen.',
          ),
          schedule: NotificationCalendar.fromDate(date: scheduledTime),
        );
      }
    }
  }
}
