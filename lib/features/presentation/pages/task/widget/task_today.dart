import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/presentation/pages/task/widget/edit_delete.dart';

import '../../../../../helper/font/task_icon.dart';
import '../../../../domain/entity/task.dart';
import '../../../state/task_state.dart';

class ItemToday extends StatefulWidget {

  Task task;
  ItemToday({super.key, required this.task});

  @override
  State<ItemToday> createState() => _ItemTodayState();
}

class _ItemTodayState extends State<ItemToday> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      // height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.grey)]
      ),
      child: ListTile(
        title: Text(widget.task.title!, maxLines:  10,),
        subtitle: widget.task.remindTime != null ? Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              const Icon(TaskIcon.clock, size: 15, color: Colors.deepOrange),
              Text(widget.task.remindTime!),
            ],
          ),
        ) : null,
        leading: IconButton(icon: widget.task.state! ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: const Icon(TaskIcon.done, color: Colors.white, size: 20)) : const Icon(Icons.circle_outlined),
            onPressed: () {
              context.read<TaskState>().changeState(widget.task);
            }),
        trailing: EditDelete(task: widget.task),
      ),
    );
  }
}


