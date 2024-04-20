import 'package:flutter/material.dart';
import 'package:stravaclone/features/domain/usecase/get_data_task.dart';

import '../../data/models/task_model.dart';
import '../../domain/entity/task.dart';

enum CurrentPage {
  Today,
  Planned,
  Task,
}

class TaskState with ChangeNotifier {
  // String backgroundImage;
  Color color = Colors.yellow;
  bool isFocus = false;
  List<Task> tasks = [];
  GetDataTask api;
  DateTime? selectedDateTime = DateTime.now();
  TimeOfDay? selectedTimeOfDay;
  TaskState({required this.api});
  CurrentPage currentPage = CurrentPage.Today;

  Future<void> addTask(TaskModel newTask) async {
    tasks.add(newTask);
    notifyListeners();
    String? id = await api.saveTask(task: newTask);
    newTask.id = id;
  }
  Future<void> loadTask() async {
    tasks = await api.getAllTask();
    notifyListeners();
  }
  void resetSelectedTimeOfDay() {
    selectedTimeOfDay = null;
    notifyListeners();
  }
  void changeFocus (bool value) {
    isFocus = value;
    notifyListeners();
  }

  Future<void> changeState(Task task) async {
    task.state = !task.state!;
    // add function to save this state to firebase
    api.updateTask(task: task);
    notifyListeners();
  }
  Future<void> updateTask(Task task) async {
    api.updateTask(task: task);
    notifyListeners();
  }
  Future<void> deleteTask(Task task) async {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].id == task.id) {
        tasks.removeAt(i);
        break;
      }
    }
    api.deleteTask(task: task);
    notifyListeners();
  }
  void changeCurrentPage(CurrentPage newCurrentPage) {
    currentPage = newCurrentPage;
    notifyListeners();
  }
}