import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clear_flutterapp/constants.dart';
import 'package:intl/intl.dart';
import 'package:clear_flutterapp/Models/todo_item_model.dart';
import 'package:clear_flutterapp/ViewModel/todo_viewmodel.dart';
import 'package:clear_flutterapp/Utils/helper.dart';
import 'package:clear_flutterapp/Widgets/add_item.dart';
import 'dart:math';
import 'dart:async';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isLoadingData = false;
  bool dragDetected = false;
  bool downDragDetected = false;
  bool createItemShowing = false;
  TextEditingController controller = TextEditingController();
  double percent = 0.0;
  FocusNode focusNode = FocusNode();
  String selectedDateTime = "";
  DateTime? selectedDate;
  TODOViewModel model = TODOViewModel();
  //Timer? _timer;

  @override
  void initState() {
    super.initState();
     // isLoadingData = true;
      fetchData();
  }


  void fetchData() async {
    isLoadingData =  await model.fetchTodos();
    print('isloading $isLoadingData');
    setState(() {

    });

  }
  @override
  void dispose() {
    // _timer?.cancel();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  // void startTimer() {
  //   const oneSec = const Duration(milliseconds: 50);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //         (Timer timer) {
  //       if (percent >= 1) {
  //         print('Timer ended');
  //         dragDetected = false;
  //         downDragDetected = false;
  //         percent = percent < 1.0 ? 0 : percent;
  //         if (percent >= 1.0) {
  //           focusNode.requestFocus();
  //           createItemShowing = true;
  //         }
  //         setState(() {});
  //         timer.cancel();
  //       } else {
  //         print('Timer start');
  //         downDragDetected = true;
  //         if (percent < 1.0) {
  //           percent += 0.10;
  //           print(percent);
  //           setState(() {});
  //         } else {
  //           timer.cancel();
  //         }
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.TODO_LIST_TITLE),
        centerTitle: true,
      ),
      body: isLoadingData ? Container (
        child: Listener (
          onPointerMove: (move) {
            if (move.localDelta.dy > 2.0) {
              downDragDetected = true;
              if (percent < 1.0) {
                percent += 0.10;
              } else {
                dragDetected = false;
                downDragDetected = false;
                percent = percent < 1.0 ? 0 : percent;
                if (percent >= 1.0) {
                  focusNode.requestFocus();
                }
              }
              setState(() {});
            }
            print("pointer ${move.localDelta}");

          },
          child: Container(
            height: double.infinity,
            width: double.infinity,

            child: Column(
              children: [
                Container(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.006) // perspective
                      ..rotateX(percent < 1.0
                          ? pi * -0.5 * (1.0 - percent)
                          : pi * 0),
                    alignment: FractionalOffset.bottomCenter,

                    child: Container(
                      height: 70 * percent,
                      child: AddItem(
                          focusNode: focusNode,
                          downDragDetected: downDragDetected,
                          getDateSelected: _getDateSelected,
                          selectedDateTime: selectedDateTime,
                          getItemCreated: _getItemCreated,
                          controller: controller),

                    ),
                  ),
                ),
                Expanded(
                  child: IgnorePointer(
                    ignoring: createItemShowing,
                    child:  ReorderableListView(
                      onReorder: _getReorder,
                      children: model.todos.isNotEmpty
                          ? getListItems(model.todos, _getDeleteItem,
                          _getDoneItem, _setListState)
                          : getEmptyListView(createItemShowing),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ): Center(child: Text('Data is loading')),
    );
  }



  _setListState() {
    setState(() {});
  }

  _getReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    // BlocProvider.of<TodosBloc>(context).add(ReorderTodos(oldIndex, newIndex));
  }

  _getDeleteItem(int index) {
    print('delete');
    model.deleteTODO(index);
    setState(() {

    });
    // BlocProvider.of<TodosBloc>(context).add(DeleteTodo(index));
  }

  _getDoneItem(int index) {
    print('done');
    model.markDoneTODO(index);
    setState(() {

    });
    // BlocProvider.of<TodosBloc>(context).add(MarkDone(index));
  }
  _getItemCreated(String task, DateTime reminderDateTime) {
    percent = 0;
    createItemShowing = false;
    if (task != null && task.isNotEmpty) {
      print(reminderDateTime);
      TodoItemModel item = TodoItemModel(task,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          reminderDate: selectedDateTime);
      model.createTODO(item, reminderDateTime);
      setState(() {

      });
    }
    selectedDateTime = "";
  }

  _getDateSelected(val) {
    setState(() {
      DateFormat df = DateFormat(Constant.DATE_FORMAT);
      selectedDateTime = df.format(val);
    });
  }
}

