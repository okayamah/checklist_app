import 'dart:async';
import 'dart:core';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/entity/task.dart';
import 'package:checklist_app/entity/todo_task.dart';
import 'package:checklist_app/models/todo_edit_view_model.dart';
import 'package:checklist_app/provider/db_provider.dart';

class TaskBloc {
  final _tableName = "Task";
  final _todoController = StreamController<List<Task>>();
  Stream<List<Task>> get taskStream => _todoController.stream;

  getTasks() async {
    _todoController.sink.add(await selectAll());
  }

  TaskBloc() {
    getTasks();
  }

  dispose() {
    _todoController.close();
  }

  Future<List<Task>> selectAll() async {
    final db = await DBProvider.db.database;
    // var res = await db.query("TodoTask", where: 'todoId = ?', whereArgs: [todoId]);
    var res = await db.query(_tableName);
    List<Task> list =
        res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  Future<TodoEditViewModel> selectTasksByTodoId(Checklist todo) async {
    final db = await DBProvider.db.database;
    var res =
        await db.query("TodoTask", where: 'todoId = ?', whereArgs: [todo.id]);
    // var res = await db.query("TodoTask");
    print(res.toString());
    List<TodoTask> list =
        res.isNotEmpty ? res.map((c) => TodoTask.fromMap(c)).toList() : [];
    TodoEditViewModel viewModel = TodoEditViewModel.init();

    for (TodoTask cur in list) {
      var res =
          await db.query(_tableName, where: 'id = ?', whereArgs: [cur.taskId]);
      if (res.isNotEmpty) {
        TaskInfo taskInfo = new TaskInfo();
        taskInfo.task = res.map((c) => Task.fromMap(c)).toList()[0];
        taskInfo.status = cur.status == "1";
        viewModel.taskList.add(taskInfo);
      }
    }
    viewModel.checklist = todo;
    return viewModel;
  }

  Future<List<Task>> selectForTodo(String todoId) async {
    final db = await DBProvider.db.database;
    var res =
        await db.query("TodoTask", where: 'todoId = ?', whereArgs: [todoId]);
    // var res = await db.query("TodoTask");
    print(res.toString());
    List<TodoTask> list =
        res.isNotEmpty ? res.map((c) => TodoTask.fromMap(c)).toList() : [];
    List<Task> tasks = new List<Task>();

    for (TodoTask cur in list) {
      var res =
          await db.query(_tableName, where: 'id = ?', whereArgs: [cur.taskId]);
      if (res.isNotEmpty) {
        tasks.add(res.map((c) => Task.fromMap(c)).toList()[0]);
      }
    }
    return tasks;
  }

  Future<int> insertTaskWithTodo(TaskInfo taskInfo, String todoId) async {
    taskInfo.task.assignUUID();
    // DBProvider.db.createTodo(todo);
    final db = await DBProvider.db.database;
    var task = await db.query(_tableName,
        where: 'title = ?', whereArgs: [taskInfo.task.title]);

    // 既に存在するアイテムであればtaskIdを上書きする.
    var taskId = taskInfo.task.id;
    var ret;
    if (task.length > 0) {
      taskId = task.map((c) => Task.fromMap(c)).toList()[0].id;
    } else {
      ret = await db.insert(_tableName, taskInfo.task.toMap());
    }

    // 中間テーブルへのinsert
    if (todoId != null && todoId.isNotEmpty) {
      Map<String, dynamic> todoTasks = {
        "todoId": todoId,
        "taskId": taskId,
        "status": taskInfo.status == false ? "0" : "1"
      };
      await db.insert("TodoTask", todoTasks);
    }

    getTasks();
    return ret;
  }

  Future<int> insertTasks(List<TaskInfo> tasks) async {
    tasks.forEach((e) {
      e.task.assignUUID();
    });
    final db = await DBProvider.db.database;

    var ret = 0;
    for (var taskInfo in tasks) {
      var task = await db.query(_tableName,
          where: 'title = ?', whereArgs: [taskInfo.task.title]);
      if (task.length == 0) {
        ret += await db.insert(_tableName, taskInfo.task.toMap());
      }
      // ret += await db.insert(_tableName, task.task.toMap());
    }

    return ret;
  }

  update(TaskInfo taskInfo, String todoId) async {
    // DBProvider.db.updateTodo(todo);
    final db = await DBProvider.db.database;
    await db.update(_tableName, taskInfo.task.toMap(),
        where: "id = ?", whereArgs: [taskInfo.task.id]);

    // 中間テーブルへのupdate
    if (todoId != null && todoId.isNotEmpty) {
      Map<String, dynamic> todoTasks = {
        "todoId": todoId,
        "taskId": taskInfo.task.id,
        "status": taskInfo.status == false ? "0" : "1"
      };
      await db.update("TodoTask", todoTasks,
          where: "todoId = ? and taskId = ?",
          whereArgs: [todoId, taskInfo.task.id]);
    }

    getTasks();
  }

  delete(String id, String todoId) async {
    // DBProvider.db.deleteTodo(id);
    final db = await DBProvider.db.database;
    db.delete(_tableName, where: "id = ?", whereArgs: [id]);

    // 中間テーブルへのdelete
    if (todoId != null && todoId.isNotEmpty) {
      await db.delete("TodoTask",
          where: "todoId = ? and taskId = ?", whereArgs: [todoId, id]);
    }

    getTasks();
  }
}
