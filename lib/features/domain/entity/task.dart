import 'package:equatable/equatable.dart';

class Task with EquatableMixin{
  String? id;
  String? title;
  bool? state;
  String? date;
  String? remindTime;
  Task({required this.title, required this.date, required this.state, this.remindTime, this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [
    title, state, date, remindTime
  ];
}