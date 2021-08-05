import 'package:clear_flutterapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:clear_flutterapp/Utils/helper.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

DateTime? selectedDate;

class AddItem extends StatelessWidget {

  AddItem(
      {required this.focusNode,
        required this.downDragDetected,
        required this.getDateSelected,
        required this.selectedDateTime,
        required this.getItemCreated,
        required this.controller});

  final FocusNode focusNode;
  final bool downDragDetected;
  final Function getDateSelected;
  final String selectedDateTime;
  final Function getItemCreated;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.redAccent,
      title: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: downDragDetected ? Constant.CREATE_ITEM : null,
          hintStyle: TextStyle(
            color: Colors.white
          ),
        ),
        focusNode: focusNode,
        controller: controller,
        onSubmitted: (newText) {
          if (selectedDateTime == null || selectedDateTime.isEmpty){
            showToast("Select Reminder",context:context);
          } else {
            print("On Create $newText");
            controller.clear();
            getItemCreated(newText, selectedDate);
            selectedDate = null;
          }

        },

      ),
      subtitle: GestureDetector(
        onTap: () {
          print('Tapped');
          if (selectedDateTime.isEmpty) {
            selectDateTimePicker(context, getSelected);
          }
        },
        child: Text(
          selectedDateTime.isEmpty ? 'Add Reminder' : selectedDateTime,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
  getSelected(dateTime){
    selectedDate = dateTime;
    getDateSelected(dateTime);
  }
}



