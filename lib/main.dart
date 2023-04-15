import 'package:flutter/material.dart';
import 'package:mobileapp/api/push_service.dart';
import 'package:mobileapp/pages/news/news.dart';

void main() {
  runApp(const MyApp());
  PushService().connect();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Главная страница',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: NewsPage(),
    );
  }
}