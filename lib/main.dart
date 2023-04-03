import 'package:flutter/material.dart';
import 'package:mobileapp/pages/news/news.dart';
import 'package:mobileapp/services/storage.dart';

import 'pages/MainDrawer.dart';
import 'pages/auth/login.dart';

void main() {
  runApp(const MyApp());
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