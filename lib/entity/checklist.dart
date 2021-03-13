import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Checklist {
  String id;
  String title;
  DateTime dueDate;
  String note;
  String icon;

  Checklist({this.id, @required this.title, @required this.dueDate, @required this.note, this.icon});
  Checklist.newTodo() {
    title = "";
    dueDate = DateTime.now();
    note = "";
    icon = "";
  }

  assignUUID() {
    id = Uuid().v4();
  }

  // staticでも同じ？
  factory Checklist.fromMap(Map<String, dynamic> json) => Checklist(
    id: json["id"],
    title: json["title"],
    // DateTime型は文字列で保存されているため、DateTime型に変換し直す
    dueDate: DateTime.parse(json["dueDate"]).toLocal(), 
    note: json["note"], 
    icon: json["icon"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    "dueDate": dueDate.toUtc().toIso8601String(),
    "note": note,
    "icon": icon
  };
}