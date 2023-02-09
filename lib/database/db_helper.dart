import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/models/tasks.dart';

class DBHelper{
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'Tasks';

  static Future<void> initDb() async {
    if(_db!= null){
      return ;
    }
    try{
      String path = '${await getDatabasesPath()}Tasks.db';
      _db = await openDatabase(
          path,
        version: _version,
        onCreate: (db, version){
            debugPrint('creating a new one');
            return db.execute(
              "CREATE TABLE $_tableName("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "title STRING, note TEXT, date STRING, "
                  "startTime STRING, endTime STRING, "
                  "remind INTEGER, repeat STRING, "
                  "color INTEGER, "
                  "isCompleted INTEGER) ",
            );
        }
      );
    }
    catch(e){
      debugPrint('$e');
    }
  }

  static Future<int> insert(Task? task) async {
    debugPrint('Insert function called');
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('query func called');
    return await _db!.query(_tableName);
  }

  static Future<List<Map<String, dynamic>>> taskCompleted(Task task) async{
    String sql = 'UPDATE $_tableName SET isCompleted = 1 WHERE id = ${task.id}';
    return await _db!.rawQuery(sql);
  }

  static Future editDate(Task task, String date) async{
    debugPrint('this is final $date');
    String sql = 'UPDATE $_tableName SET date =? WHERE id =?';
    return await _db!.rawUpdate(sql, [date, '${task.id}']);
  }

  static delete (Task task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
}