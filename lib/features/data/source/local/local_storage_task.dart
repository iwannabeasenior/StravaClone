import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../../models/task_model.dart';

abstract class LocalStorageTask {
  Future<List<TaskModel>> getAllTask();
  Future<String?> savePost({required task});
  Future<void> updateTask({required task});
  Future<void> deleteTask({required task});
}
class LocalStorageTaskImpl implements LocalStorageTask {
  final _db = FirebaseFirestore.instance;
  Logger log = Logger();
  @override
  Future<List<TaskModel>> getAllTask() async {
    List<TaskModel> list = [];
    try {
      await _db.collection('task').get().then((event) {
        for (var doc in event.docs) {
          list.add(TaskModel.fromJson(doc.data(), doc.id));
        }
      });
    } catch(e) {
      log.d(e);
    }
    return list;
  }

  @override
  Future<String?> savePost({required task}) async {
    try {
      String? id;
      await _db.collection('task').add(task.toJson()).then((value) => id = value.id);
      return id;
    } catch(e) {
      log.d(e);
    }
    return null;
  }

  @override
  Future<void> updateTask({required task}) async {
    try {
      await _db.collection('task').doc(task.id).set({
        'title': task.title,
        'state': task.state,
        'date': task.date,
        'remindTime': task.remindTime,
      });
    } catch(e) {
      log.d(e);
    }
  }

  @override
  Future<void> deleteTask({required task}) async {
    try {
      await _db.collection('task').doc(task.id).delete();
    } catch(e) {
      log.d(e);
    }
  }
}