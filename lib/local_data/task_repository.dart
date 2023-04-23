import '../model/task.dart';

class TaskRepository {
  final taskDao = MyDatabase.instance.taskDao;

  Future<List<Task>> getTasks() async {
    return taskDao.getAllTasks();
  }

  Future<void> insertTask(Task task) async {
    taskDao.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    taskDao.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    taskDao.deleteTask(task);
  }
}
