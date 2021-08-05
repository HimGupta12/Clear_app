import 'package:clear_flutterapp/Models/todo_item_model.dart';
import 'package:clear_flutterapp/DataBase/CommonDatabase.dart';

class TODOViewModel {
  List<TodoItemModel> todos = [];
  FirestoreTodoDatabase todosRepository = FirestoreTodoDatabase();


  Future<bool> fetchTodos() async {
    try {
      final todo = await todosRepository.loadTodos();
      todos = todo.map(TodoItemModel.fromEntity).toList();
      print(todos.first);

    } catch (_) {
      print('Error in fetching todos');
    }
    return true;

  }

  Future<void> createTODO (TodoItemModel todo, DateTime reminder) async {
    final temTodo = todos
      ..insert(0, todo);
    todos = updateOrderIndexes(temTodo, 0, temTodo.length - 1);
    await _saveTodos(temTodo, null);
  }

  Future _saveTodos(List<TodoItemModel> todos, String? deletedId) {
    return todosRepository.syncTodos(
        todos.map((todo) => todo.toEntity()).toList(), deletedId);
  }

  List<TodoItemModel> updateOrderIndexes(List<TodoItemModel> tasks, int startIndex, int endIndex) {
    for (int i = startIndex; i <= endIndex; i++) {
      tasks[i].orderIndex = i;
    }
    return tasks;
  }

  Future<void> deleteTODO(int index) async {
    final temTodo = todos;
    TodoItemModel deletedTodo = temTodo[index];
    temTodo.removeAt(index);
    todos = temTodo;
    updateOrderIndexes(
        temTodo, index, temTodo.length - 1);
    await _saveTodos(
        temTodo.sublist(index, temTodo.length),
        deletedTodo.id);
  }

  Future<void> markDoneTODO(int markIndex) async {
    final temTodo = todos;
    TodoItemModel updatedItem = temTodo[markIndex];
    temTodo.removeAt(markIndex);
    TodoItemModel newItem = TodoItemModel(updatedItem.getTask(),
        id : DateTime.now().millisecondsSinceEpoch.toString(),reminderDate: updatedItem.reminderDate);
    newItem.markDone();
    temTodo.add(newItem);
    todos = temTodo;
    updateOrderIndexes(
        temTodo, markIndex, temTodo.length - 1);
    await _saveTodos(
        temTodo.sublist(markIndex, temTodo.length),
        updatedItem.id);
  }

  Future<void> moveTODO(int oldIndex, int newIndex) async {
    final temTodo = todos;
    TodoItemModel moveItem = temTodo[oldIndex];
    moveItem.markActive();
    temTodo.removeAt(oldIndex);
    if (newIndex != 0) {
      if (!temTodo[newIndex - 1].isActive) {
        moveItem.markDone();
      }
    } else {
      if (!temTodo[0].isActive) {
        moveItem.markDone();
      }
    }
    temTodo.insert(newIndex, moveItem);

    if (newIndex > oldIndex) {
      todos = updateOrderIndexes(temTodo, oldIndex, newIndex);
      await _saveTodos(
          temTodo.sublist(oldIndex, newIndex + 1), null);
    } else {
      todos = updateOrderIndexes(temTodo, newIndex, oldIndex);
      await _saveTodos(
          temTodo.sublist(newIndex, oldIndex + 1), null);
    }
  }
}