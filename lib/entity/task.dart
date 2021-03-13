import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String category;

  Task({this.id, @required this.title, this.category});
  Task.init() {
    title = "";
    category = "未設定";
  }

  assignUUID() {
    id = Uuid().v4();
  }

  // staticでも同じ？
  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    category: json["category"], 
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "category": category
  };
}