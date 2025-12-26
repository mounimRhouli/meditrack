import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _notifications.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  Future<void> scheduleReminder(Reminder reminder, String medName) async {
    final now = DateTime.now();
    final timeParts = reminder.time.split(':');
    var scheduledDate = DateTime(now.year, now.month, now.day, int.parse(timeParts[0]), int.parse(timeParts[1]));

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      reminder.id.hashCode,
      'Il est temps !',
      'Prenez votre médicament : $medName',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('med_reminders', 'Rappels Médicaments', importance: Importance.max),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(String id) async {
    await _notifications.cancel(id.hashCode);
  }
}