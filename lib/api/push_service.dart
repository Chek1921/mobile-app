import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobileapp/services/notification_service.dart';
import 'package:mobileapp/services/storage.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class PushService {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late IOWebSocketChannel channel;

  Future<void> connect() async {
    NotificationService.initialize(flutterLocalNotificationsPlugin);

    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://13.50.176.175:8000/ws/notify/'),
    );
    print("NSDKJFNKDJNFDJKFNJFNSDFNKNFJKFNKDNFNFJKSDFNFJKFNFJKDSKJ");

    channel.stream.listen((message) async {
      final data = json.decode(message);
      print(data);
      String username = '';
      String? _username = await SecureStorage().getUsername();
      if (_username != null) {
        username  = _username;
      } else {
        username = '';
      }
      print(username);
      if (username == data['username']) {
        NotificationService.showBigTextNotification(
          title: "Жалоба",
          body: data['text'],
          fln: flutterLocalNotificationsPlugin,
          );
        channel.sink.add('received!');
      }
    }, onDone: () {});
  }
}
