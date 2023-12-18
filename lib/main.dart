import 'package:flutter/material.dart';
import 'datetime/date_time.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //init the hive
  await Hive.initFlutter();

  var box = await Hive.openBox('myBox');

  if (box.get("START_DATE") == null) {
    // 如果不存在，创建初始数据
    box.put("START_DATE", todaysDateFormatted());
    box.put("HEAT_MAP_DATA", {});
  }

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
