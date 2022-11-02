import 'package:get/get.dart';
import 'package:to_do_list/database/db_helper.dart';
import 'package:to_do_list/models/tasks.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }
}