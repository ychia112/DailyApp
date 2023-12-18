import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/history_page.dart';

void main() async {
  //init the hive
  await Hive.initFlutter();

  var box = await Hive.openBox('myBox');
  runApp(const DailyApp());
}

class DailyApp extends StatelessWidget {
  const DailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}
