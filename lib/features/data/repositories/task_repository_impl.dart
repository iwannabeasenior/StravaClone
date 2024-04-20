import 'package:stravaclone/features/data/source/local/local_storage_task.dart';
import 'package:stravaclone/features/domain/entity/task.dart';
import 'package:stravaclone/features/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  LocalStorageTask localStorage;
  TaskRepositoryImpl({required this.localStorage});
  @override
  Future<List<Task>> getAllTask() async {
    return await localStorage.getAllTask();
  }

  @override
  Future<String?> saveTask({required task}) async {
    return await localStorage.savePost(task: task);
  }

  @override
  Future<void> updateTask({required task}) async {
    await localStorage.updateTask(task: task);
  }

  @override
  Future<void> deleteTask({required task}) async {
    await localStorage.deleteTask(task: task);
  }
}