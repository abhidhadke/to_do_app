import 'package:get/get.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/models/tasks.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get all the data from the db
  void getTasks() async {
    List<Map<String,dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
  }
}