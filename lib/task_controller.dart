import 'package:get/get.dart';
import 'package:schedule/task.dart';
import 'db_helper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  static delete(Task task) {
    DBHelper.delete(task);
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
  }
}
