import 'package:equatable/equatable.dart';
import 'package:clear_flutterapp/Models/todo_entity.dart';

class TodoItemModel extends Equatable {
  String _task;
  String id;
  bool isActive = true;
  bool swipeRightDetected = false;
  String reminderDate;
  int orderIndex;

  TodoItemModel(this._task,
      {this.id = "",
        required this.reminderDate,
        this.isActive = true,
        this.orderIndex = 0});

  getTask() => this._task;

  setTask(task) => this._task = task;

  markDone() => isActive = false;

  markActive() => isActive = true;

  @override
  List<Object> get props => [isActive, id, reminderDate, _task];

  @override
  String toString() {
    return 'Todo { isActive: $isActive, task: $_task, note: $reminderDate, id: $id }';
  }

  TodoModelEntity toEntity() {
    return TodoModelEntity(_task, id, reminderDate, isActive, orderIndex);
  }

  static TodoItemModel fromEntity(TodoModelEntity entity) {
    return TodoItemModel(entity.task, id : entity.id,
        isActive: entity.isactive,
        reminderDate: entity.reminder,
        orderIndex: entity.orderindex);
  }
}
