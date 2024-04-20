import '../entity/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTask();
  Future<String?> saveTask({required task});
  Future<void> updateTask({required task});
  Future<void> deleteTask({required task});
}