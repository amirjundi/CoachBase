import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/subscription.dart';

class NotificationService {
  // Singleton pattern
  NotificationService._privateConstructor();
  static final NotificationService instance = NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Request permissions for Android 13+
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'subscriptions_channel',
        'الاشتراكات', // Subscriptions
        channelDescription: 'إشعارات تنبيه بانتهاء الاشتراكات', // Subscription expiry alerts
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );
  }

  Future<void> scheduleSubscriptionAlerts(Subscription sub, String playerName) async {
    if (sub.id == null) return;
    
    // We create unique notification IDs based on the subscription ID.
    // E.g., sub.id * 10 for "3 days left", sub.id * 10 + 1 for "Expired today"
    final baseId = sub.id! * 10;
    
    // Cancel any existing notifications for this subscription
    await cancelSubscriptionAlerts(sub.id!);

    final now = DateTime.now();

    // 1. "3 Days Left" alert
    final threeDaysBefore = sub.endDate.subtract(const Duration(days: 3));
    // Set time to 10:00 AM
    var alertTime1 = DateTime(threeDaysBefore.year, threeDaysBefore.month, threeDaysBefore.day, 10, 0);
    
    if (alertTime1.isAfter(now)) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: baseId,
        title: 'تنبيه اشتراك', // Subscription Alert
        body: 'اشتراك اللاعب $playerName سينتهي بعد 3 أيام', // Player's subscription ends in 3 days
        scheduledDate: tz.TZDateTime.from(alertTime1, tz.local),
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    // 2. "Expired Today" alert
    // Set time to 10:00 AM on the day of expiry
    var alertTime2 = DateTime(sub.endDate.year, sub.endDate.month, sub.endDate.day, 10, 0);
    
    if (alertTime2.isAfter(now)) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: baseId + 1,
        title: 'انتهاء اشتراك', // Subscription Expired
        body: 'اشتراك اللاعب $playerName ينتهي اليوم!', // Player's subscription ends today!
        scheduledDate: tz.TZDateTime.from(alertTime2, tz.local),
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    // 3. "10 Days Passed - Locker Check" alert
    var alertTime3 = DateTime(sub.endDate.year, sub.endDate.month, sub.endDate.day, 10, 0).add(const Duration(days: 10));

    if (alertTime3.isAfter(now)) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: baseId + 2,
        title: 'سحب الخزانة', // Unassign Locker
        body: 'انتهى اشتراك اللاعب $playerName منذ 10 أيام. يرجى سحب خزانته إن وجدت.', // Subscription ended 10 days ago, please unassign locker.
        scheduledDate: tz.TZDateTime.from(alertTime3, tz.local),
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelSubscriptionAlerts(int subscriptionId) async {
    final baseId = subscriptionId * 10;
    await _flutterLocalNotificationsPlugin.cancel(id: baseId);
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 1);
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 2);
  }
}
