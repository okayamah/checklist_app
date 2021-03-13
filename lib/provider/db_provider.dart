import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  static final _tableColumnList = {
    "Todo": "("
        "id TEXT PRIMARY KEY,"
        "title TEXT,"
        "dueDate TEXT,"
        "note TEXT,"
        "icon TEXT"
        ")",
    "Task": "("
        "id TEXT PRIMARY KEY,"
        "title TEXT,"
        "status TEXT,"
        "category TEXT"
        ")",
    "TodoTask": "("
        "todoId TEXT,"
        "taskId TEXT,"
        "status TEXT"
        ")",
  };

  Future<Database> get database async {
    if (_database != null) return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // import 'package:path/path.dart'; が必要
    // なぜか サジェスチョンが出てこない
    String path = join(documentsDirectory.path, "TodoDB.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    // sqliteではDate型は直接保存できないため、文字列形式で保存する
    for (var tableName in _tableColumnList.keys) {
      await db
          .execute("CREATE TABLE $tableName ${_tableColumnList[tableName]}");
    }
  }
}
