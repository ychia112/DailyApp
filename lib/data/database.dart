import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase{
  List toDoList = [];
  //reference our box
  final _myBox = Hive.box('mybox');

  //first time opening this app
  void createInitialData(){
    toDoList = [
      ["Swipe right to add an item.", false],
      ["Swipe right on the item to cancel it.", false],
    ];
  }

  //load the data from database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  //update the database
  void updateDatabase(){
    _myBox.put("TODOLIST", toDoList);
  }

}