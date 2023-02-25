import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/components/habit_tile.dart';
import 'package:habbit_tracker_app/components/monthly_summary.dart';
import 'package:habbit_tracker_app/components/my_fab.dart';
import 'package:habbit_tracker_app/components/my_alert_box.dart';
import 'package:habbit_tracker_app/data/habbit_database.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //data structure for todays habit list
   HabitDatabase db=HabitDatabase();
   final _myBox=Hive.box("Habit_Database");

   @override
  void initState() {

    if(_myBox.get("CURRENT_HABIT_LIST")==null){
      db.createDefaulData();
    }
    else{
      db.LoadData();
    }
    db.updateDatabase();
    super.initState();
  }
  
  // checkbox was taped
  void checkboxTapped(bool? value, int index){
    setState(() {
      db.todaysHabbitList[index][1]= value;
    });
    db.updateDatabase();
  }
 
 final _newHabbitNameController=TextEditingController();

  //create a  new habbit
  void createNewhabbit(){
    showDialog(
      context: context, 
      builder: (context){
        return MyAlertBox(
          hintText: 'Enter Habit Name..',
          controller: _newHabbitNameController,
          onSave: saveNewHabbit,
          onCancel: cancelDialogBox,
        );
      });
  }
  //save new habbit
  void saveNewHabbit(){
    setState(() {
        db.todaysHabbitList.add([_newHabbitNameController.text,false]);
    });
  
    _newHabbitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }


  //cancel new habbit
  void cancelDialogBox(){
    _newHabbitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabbitSettings(int index){
    showDialog(
      context: context, 
      builder: (context){
        return MyAlertBox(
          hintText: db.todaysHabbitList[index][0],
          controller: _newHabbitNameController, 
          onCancel: cancelDialogBox, 
          onSave: ()=>saveExistingHabbit(index));
      }
      );
  }

  void saveExistingHabbit(int index){
    setState(() {
      db.todaysHabbitList[index][0]= _newHabbitNameController.text;
    });
    _newHabbitNameController.clear();
    Navigator.of(context).pop();
  db.updateDatabase();
  }

  void deleteHabbit(int index){
    setState(() {
      db.todaysHabbitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyfloatingActionButton(
        onPressed: createNewhabbit,
      ),
      body: ListView(
        children: [

        MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),

         ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: db.todaysHabbitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
              habbitName: db.todaysHabbitList[index][0], 
              habitCompleted: db.todaysHabbitList[index][1], 
              onChanged: (value)=>checkboxTapped(value, index),
              settingsTapped:(value)=> openHabbitSettings(index),
              deleteTapped: (value)=> deleteHabbit(index),
              );
          },
      ),
        ],
      ),
    );
  }
}