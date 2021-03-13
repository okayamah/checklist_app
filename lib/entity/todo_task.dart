import 'package:flutter/material.dart';

class TodoTask {
  String todoId;
  String taskId;
  String status;

  TodoTask({this.todoId, @required this.taskId, @required this.status});
  TodoTask.init() {
    todoId = "";
    todoId = "";
    status = "0";
  }

  // staticでも同じ？
  factory TodoTask.fromMap(Map<String, dynamic> json) => TodoTask(
    todoId: json["todoId"],
    taskId: json["taskId"], 
    status: json["status"], 
  );

  Map<String, dynamic> toMap() => {
    "todoId": todoId,
    "taskId": taskId,
    "status": status,
  };
}