// import 'dart:async';
// import 'dart:core';

import 'package:clear_flutterapp/Models/todo_entity.dart';

abstract class TodosDataBaseModel {
  Future<List<TodoModelEntity>> loadTodos();

  Future<void> syncTodos(List<TodoModelEntity> list, String deletedId) async {}

  Future<void> deleteTodo(String id);

  Future<void> updateTodo(TodoModelEntity todo);

}
