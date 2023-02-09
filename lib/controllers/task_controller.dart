import 'package:get/get.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/models/tasks.dart';

class TaskController extends GetxController{


  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get all the data from the db
  void getTasks(String date) async {
    List<Map<String,dynamic>> tasks = await DBHelper.query(date);
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void taskComplete(Task task) async {
    await DBHelper.taskCompleted(task);
  }

  void editDate(Task task, String date) async{
    await DBHelper.editDate(task, date);
  }

  void delete(Task task){
    DBHelper.delete(task);
  }
}