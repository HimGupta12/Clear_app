
import 'package:clear_flutterapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:clear_flutterapp/Widgets/todo_items.dart';

List<Widget> getListItems(tasks, getDeleteItem, getDoneItem, setListState) {
  List<Widget> widgetList = [];
  // List<Widget> widgetList = new List.filled(0, );
  for (var i = 0; i < tasks.length; i++) {
    widgetList.add(ToDoItemsWidget(
        key: Key(tasks[i].id),
        itemCount: tasks.length,
        item: tasks[i],
        index: i,
        getDeleteItem: getDeleteItem,
        getDoneItem: getDoneItem,
        setListState: setListState));
  }
  return widgetList;
}

List<Widget> getEmptyListView(createItemShowing) {
  List<Widget> widgetList = [];
  widgetList.add(createItemShowing
      ? SizedBox(key: Key("0"))
      : ListTile(
      key: Key("0"),
      tileColor: Colors.red,
      title: Text(
          'Drag Down To create an itme',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
      ),
  ));
  return widgetList;
}

selectDateTimePicker(BuildContext context, Function onSelected) async {
  DateTime? pickedDate = await showModalBottomSheet<DateTime>(
    context: context,
    builder: (context) {
      DateTime? tempPickedDate;
      return Container(
        height: 250,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text(Constant.CANCEL),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text(Constant.DONE),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedDate);
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(
              child: Container(
                child: CupertinoDatePicker(
                  minimumDate: DateTime.now(),
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  if (pickedDate != null) {
    onSelected(pickedDate);
  }
}