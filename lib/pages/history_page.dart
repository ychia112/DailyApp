import 'package:flutter/material.dart';
import 'package:flutter_application_dailyapp/data/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/todo_tile.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final DateTime value;
  const HistoryPage({super.key, required this.value});


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ToDoDataBase db = ToDoDataBase();
  List toDoListForSelectedDate = [];
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoListForSelectedDate[index][1] = value!;
      // 在这里添加更新数据库的逻辑
      db.updateDatabase();
    });
  }

  // 定义 deleteTask 方法
  void deleteTask(int index) {
    setState(() {
      toDoListForSelectedDate.removeAt(index);
      // 在这里添加更新数据库的逻辑
      db.updateDatabase();
    });
  }
  @override
  void initState() {
    super.initState();
    // 在初始化时加载指定日期的 to-do list
    toDoListForSelectedDate = db.getToDoListByDate(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd().format(widget.value);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 100.0,
            // 設置擴展高度
            backgroundColor: Colors.transparent,
            centerTitle: false,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(
                start: 12.0,
                bottom: 12.0,
              ),
              centerTitle: false,
              title: Text(
                formattedDate,
                style: GoogleFonts.abrilFatface(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                // 返回你的列表項
                return ToDoTile(
                  taskName: toDoListForSelectedDate[index][0],
                  taskCompleted: toDoListForSelectedDate[index][1],
                  onChanged: null,
                  deleteFunction: null,
                );
              },
              childCount: toDoListForSelectedDate.length,
            ),
          ),
        ],
      ),
    );
  }
}
