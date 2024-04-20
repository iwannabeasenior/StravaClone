
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/domain/entity/task.dart';
import 'package:stravaclone/features/presentation/state/task_state.dart';

import '../../../../../helper/utility.dart';


class EditDelete extends StatefulWidget {

  Task task;
  EditDelete({super.key,  required this.task});

  @override
  State<EditDelete> createState() => _EditDeleteState();
}

class _EditDeleteState extends State<EditDelete> {
  TextEditingController controller = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  String? title;
  @override
  Widget build(BuildContext context) {
    var api = context.read<TaskState>();
    return PopupMenuButton<IconData>(
      onSelected: (value) {
        if (value == Icons.edit) {
          showDialog(
              context: context,
              builder: (context) {
                // return Container(color: Colors.deepOrange);
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: FractionallySizedBox(
                    alignment: Alignment.center,
                    heightFactor: 0.5,
                    widthFactor: 1,
                    child: Container(
                      color: Colors.deepOrange,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: widget.task.title,
                            onChanged: (value) {

                            },
                          ),
                          IconButton(
                            onPressed: () async {
                              TimeOfDay? subTime = await showTimePicker(
                                  context: context,
                                  initialTime: widget.task.remindTime == null ?  TimeOfDay.now() : Utility.formatTimeOfDay(widget.task.remindTime!),
                              );
                              if (subTime != null) {
                                time = subTime;
                              }
                            },
                            icon: Icon(Icons.timer),
                          ),
                          IconButton(
                              onPressed: () async {
                                DateTime? subDate = await showDatePicker(context: context, initialDate: DateTime.parse(widget.task.date! + '23:59:59'), firstDate: DateTime(1000, 1, 1), lastDate: DateTime(3000, 1, 1));
                                if (subDate != null) {
                                  date = subDate;
                                }
                              },
                              icon: Icon(Icons.date_range)
                          ),
                          IconButton(
                              onPressed: () {
                                if (title != null) {
                                  widget.task.title = title;
                                }
                                if (date != null) {
                                  widget.task.date = date.toString().substring(0, 11);
                                }
                                if (time != null) {
                                  widget.task.remindTime = Utility.formatTime(time);
                                }
                                api.updateTask(widget.task);
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.save_alt_sharp)
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          api.deleteTask(widget.task);
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<IconData>>[
        PopupMenuItem<IconData>(
          value: Icons.edit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.edit),
              Text('Edit')
            ],
          ),
        ),
        PopupMenuItem<IconData>(
          value: Icons.delete,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.delete),
              Text('Delete')
            ],
          ),
          )
      ], 
    );
  }
}