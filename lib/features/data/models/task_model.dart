import 'package:stravaclone/features/domain/entity/task.dart';

class TaskModel extends Task {
  TaskModel({required super.title, required super.date, required super.state, super.remindTime, super.id});
  factory TaskModel.fromJson(Map<String, dynamic> map, String id)  {
    return TaskModel(title: map['title'] ?? 'Unknown', date: map['date'] ?? 'Unknown', state: map['state'] ?? false, remindTime: map['remindTime'], id: id);
  }
  Map<String, dynamic> toJson() {
   return {
     'title': title,
     'date': date,
     'state': state,
     'remindTime': remindTime,
   };
  }
}