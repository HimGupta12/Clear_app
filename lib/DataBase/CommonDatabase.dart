import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clear_flutterapp/DataBase/database_model.dart';
import 'package:clear_flutterapp/Models/todo_entity.dart';

class FirestoreTodoDatabase implements TodosDataBaseModel {

  String path = 'list';
  String orderIndex = 'orderindex';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> deleteTodo(String id) {
    return firestore.collection(path).doc(id).delete();
  }

  @override
  Future<void> updateTodo(TodoModelEntity todo) {
    return firestore
        .collection(path)
        .doc(todo.id)
        .update(todo.toJson());
  }

  @override
  Future<List<TodoModelEntity>> loadTodos() async {
    var snapshots =
    await firestore.collection(path).orderBy(orderIndex).get();
    return snapshots.docs
        .map((e) => TodoModelEntity(
      e['task'],
      e.id,
      e['reminder'] ?? '',
      e['isactive'] ?? false,
      e['orderindex'] ?? 0,
    ))
        .toList();
  }

  @override
  Future<void> syncTodos(
      List<TodoModelEntity> entityList, String? deletedItemId) async {
    //Create a batch
    var batch = firestore.batch();
    entityList.forEach((todoEntity) {

      batch.set(firestore.collection(path).doc(todoEntity.id),
          todoEntity.toJson(), SetOptions(merge: true));
    });
    if (deletedItemId != null) {
      batch.delete(firestore.collection(path).doc(deletedItemId));
    }
    await batch.commit();
  }
}
