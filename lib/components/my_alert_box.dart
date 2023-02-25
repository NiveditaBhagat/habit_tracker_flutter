import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const MyAlertBox({super.key, required this.controller, required this.onCancel,required this.onSave,required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style:const  TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),

      ),
      actions: [
        MaterialButton(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8.0) ),
          onPressed:onSave,
           child:Text('Save',style: TextStyle(color:Colors.white)),
          color:Colors.deepPurple,
          ),
           MaterialButton(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8.0) ),
          onPressed:onCancel,
           child:  Text('Cancel',style: TextStyle(color:Colors.white)),
          color:Colors.deepPurple,
          ),
      ],
    );
  }
}