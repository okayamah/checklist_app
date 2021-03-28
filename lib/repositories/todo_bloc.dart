import 'dart:async';
import 'dart:core';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/models/todo_list_view_model.dart';
import 'package:checklist_app/provider/db_provider.dart';

class ChecklistBloc {
  bool _isDisposed = false;
  final _tableName = "Todo";
  final _todoController = StreamController<TodoListViewModel>();
  Stream<TodoListViewModel> get todoStream => _todoController.stream;

  getTodos() async {
    try {
      if (!_todoController.isClosed && !_isDisposed) {
        _todoController.sink.add(await selectAllWithStatus());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ChecklistBloc() {
    getTodos();
  }

  dispose() {
    _isDisposed = true;
    _todoController.close();
  }

  Future<List<Checklist>> selectAll() async {
    final db = await DBProvider.db.database;
    var res = await db.query(_tableName);
    List<Checklist> list =
        res.isNotEmpty ? res.map((c) => Checklist.fromMap(c)).toList() : [];
    return list;
  }

  Future<TodoListViewModel> selectAllWithStatus() async {
    final db = await DBProvider.db.database;
    var res = await db.query(_tableName);
    List<Checklist> list =
        res.isNotEmpty ? res.map((c) => Checklist.fromMap(c)).toList() : [];

    TodoListViewModel viewModel = TodoListViewModel.init();
    for (var item in list) {
      var tasks = await db.query("TodoTask",
          where: 'todoId = ? and status = "0"', whereArgs: [item.id]);
      print("todo id=${item.id}, 未完了タスク数=${tasks.length}");

      ChecklistInfo value = new ChecklistInfo(
          check: item, status: tasks.length == 0 ? true : false);
      viewModel.checklist.add(value);
    }
    return viewModel;
  }

  Future<Map<DateTime, List<dynamic>>> selectGroupByDate() async {
    final db = await DBProvider.db.database;
    var res = await db.query(_tableName);
    List<Checklist> list =
        res.isNotEmpty ? res.map((c) => Checklist.fromMap(c)).toList() : [];
    Map<DateTime, List> viewModel = new Map<DateTime, List>();

    for (Checklist cur in list) {
      var item = {'name': cur.title, 'isDone': true};
      if (viewModel.containsKey(cur.dueDate)) {
        viewModel[cur.dueDate].add(item);
      } else {
        List list = new List();
        list.add(item);
        viewModel[DateTime(
            cur.dueDate.year, cur.dueDate.month, cur.dueDate.day)] = list;
      }
    }
    return viewModel;
  }

  Future<String> insert(Checklist todo) async {
    todo.assignUUID();
    // DBProvider.db.createTodo(todo);
    final db = await DBProvider.db.database;
    await db.insert(_tableName, todo.toMap());
    getTodos();
    return todo.id;
  }

  Future<void> update(Checklist todo) async {
    // DBProvider.db.updateTodo(todo);
    final db = await DBProvider.db.database;
    await db.update(_tableName, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    getTodos();
  }

  delete(String id) async {
    // DBProvider.db.deleteTodo(id);
    final db = await DBProvider.db.database;
    db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    getTodos();
  }
}
