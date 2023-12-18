import 'package:flutter_application_dailyapp/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box('mybox');
class ToDoDataBase{
  List toDoList = [];
  Map<DateTime, int> heatMapDataSet = {};

  List getToDoListByDate(DateTime date) {
    String formattedDate = convertDateTimeToString(date);
    return _myBox.get(formattedDate) ?? [];
  }

  //first time opening this app
  void createInitialData(){
    toDoList = [
      ["Swipe right to add an item.", false],
      ["Swipe right on the item to cancel it.", false],
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //load the data from database
  void loadData(){
    if(_myBox.get(todaysDateFormatted()) == null){
      toDoList = _myBox.get("TODOLIST");
      for (int i = 0; i < toDoList.length; i++){
        toDoList[i][1] = false;
      }
    } else {
      toDoList = _myBox.get(todaysDateFormatted());
    }

  }

  //update the database
  void updateDatabase(){
    _myBox.put(todaysDateFormatted(), toDoList);
    _myBox.put("TODOLIST", toDoList);

    calculateHabitPercentages();
    loadHeatMap();
  }
  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < toDoList.length; i++) {
      if (toDoList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = toDoList.isEmpty
        ? '0.0'
        : (countCompleted / toDoList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }

}