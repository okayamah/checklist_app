import 'dart:async';
import 'dart:core';
import 'package:checklist_app/models/checklist.dart';
import 'package:checklist_app/repositories/db_provider.dart';

class ChecklistBloc {
  final _todoController = StreamController<List<Checklist>>();
  Stream<List<Checklist>> get todoStream => _todoController.stream;

  getTodos() async {
    _todoController.sink.add(await DBProvider.db.getAllTodos());
  }

  ChecklistBloc() {
    getTodos();
  }

  dispose() {
    _todoController.close();
  }

  create(Checklist todo) {
    todo.assignUUID();
    DBProvider.db.createTodo(todo);
    getTodos();
  }

  update(Checklist todo) {
    DBProvider.db.updateTodo(todo);
    getTodos();
  }

  delete(String id) {
    DBProvider.db.deleteTodo(id);
    getTodos();
  }
}
