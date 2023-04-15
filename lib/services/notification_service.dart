import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('ic_android_black_24dp');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          "0",
          'you_can_name_it_whatever1',
          playSound: false,
          importance: Importance.max,
          priority: Priority.high,
        );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await fln.show(id, title, body, not);
  }
}
