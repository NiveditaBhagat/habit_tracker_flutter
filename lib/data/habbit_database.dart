import 'package:habbit_tracker_app/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//reference our box
final _myBox= Hive.box("Habit_Database");

class HabitDatabase{
  List todaysHabbitList=[];
  Map<DateTime, int> heatMapDataSet={};
  //create initial default data
  void createDefaulData(){
    todaysHabbitList=[
      ["Run",false],
      ["Read",false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }
  //load the data if it already exist
  void LoadData(){
    //if it's a new day , get habbit list from database
    if(_myBox.get(todaysDateFormatted())==null){
      todaysHabbitList=_myBox.get("CURRENT_HABIT_LIST");
      for(int i=0;i<todaysHabbitList.length;i++){
        todaysHabbitList[i][1]=false;
      }
    }else{
      todaysHabbitList= _myBox.get(todaysDateFormatted());
    }
    //if it's not a new day, load today' list

  }

  //update database
  void updateDatabase(){
    //update todays entry
  _myBox.put(todaysDateFormatted(), todaysHabbitList);

    //update universal habbit list in case it changed(new habit, delete habbit, edit habit)
  _myBox.put("CURRENT_HABIT_LIST",todaysHabbitList);

  //calculate habbit complete percentages for each day
  CalculateHabitPercentage();

  //load heatmap
  LoadHeatMap();

  }
  
  void CalculateHabitPercentage(){
    int CountCompleted=0;
    for(int i=0;i<todaysHabbitList.length;i++){
      if(todaysHabbitList[i][1]==true){
        CountCompleted++;
      }
    }
    
    String percent = todaysHabbitList.isEmpty
        ? '0.0'
        : (CountCompleted / todaysHabbitList.length).toStringAsFixed(1);
      
       _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void LoadHeatMap(){
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