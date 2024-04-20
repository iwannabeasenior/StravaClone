import 'package:stravaclone/features/domain/repositories/task_repository.dart';

import '../entity/task.dart';

class GetDataTask {
  TaskRepository repo;
  GetDataTask({required this.repo});
  Future<List<Task>> getAllTask() async {
    return await repo.getAllTask();
  }
  Future<String?> saveTask({required task}) async {
    return await repo.saveTask(task: task);
  }
  Future<void> updateTask({required task}) async {
    await repo.updateTask(task: task);
  }
  Future<void> deleteTask({required task}) async {
    await repo.deleteTask(task: task);
  }
}