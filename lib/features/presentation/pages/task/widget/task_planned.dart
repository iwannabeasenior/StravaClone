import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/presentation/pages/task/widget/edit_delete.dart';

import '../../../../../helper/font/task_icon.dart';
import '../../../../domain/entity/task.dart';
import '../../../state/task_state.dart';
class ItemPlanned extends StatefulWidget {

  String title;
  List<Task> tasks;
  ItemPlanned({super.key, required this.title, required this.tasks});

  @override
  State<ItemPlanned> createState() => _ItemPlannedState();
}

class _ItemPlannedState extends State<ItemPlanned> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      constraints: BoxConstraints(

      ),
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.lightGreenAccent,
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.tasks.length.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
        children: [
          for (int index = 0; index < widget.tasks.length; index++)
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListTile(
                title: Text(
                  widget.tasks[index].title!,
                  maxLines: 10,
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      widget.tasks[index].remindTime != null
                          ? Row(
                              children: [
                                const Icon(TaskIcon.clock,
                                    size: 15, color: Colors.deepOrange),
                                Text(widget.tasks[index].remindTime!),
                                const SizedBox(width: 10),
                              ],
                            )
                          : const Text(''),
                      Icon(
                        TaskIcon.calendar_alt,
                        color: widget.title == 'Earlier'
                            ? Colors.deepOrange
                            : Colors.black,
                        size: 15,
                      ),
                      Text(
                        widget.tasks[index].date!,
                        style: TextStyle(
                            fontSize: 13,
                            color: widget.title == 'Earlier'
                                ? Colors.red
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                    icon: widget.tasks[index].state!
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: const Icon(TaskIcon.done,
                                color: Colors.white, size: 20))
                        : const Icon(Icons.circle_outlined),
                    onPressed: () {
                      context
                          .read<TaskState>()
                          .changeState(widget.tasks[index]);
                    }),
                trailing: EditDelete(task: widget.tasks[index]),
              ),
            ),
        ],
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.only(top: 10, bottom: 10),
    //   margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //       color: Colors.lightBlueAccent,
    //       boxShadow: const [BoxShadow(color: Colors.grey)]
    //   ),
    //
      // child: Column(
      //   children: [
      //     Text(widget.title, style: const TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),),
      //     const SizedBox(height: 10),
      //     Container(
      //         child: ListView.builder(
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             itemCount: widget.tasks.length,
      //             itemBuilder: (context, index) => Container(
      //               margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Colors.white,
      //               ),
      //               child: ListTile(
      //                 title: Text(widget.tasks[index].title!, maxLines:  10,),
      //                 subtitle: Container(
      //                   margin: const EdgeInsets.only(top: 10),
      //                   child: Row(
      //                     children: [
      //                       widget.tasks[index].remindTime != null ?
      //                       Row(
      //                         children: [
      //                           const Icon(TaskIcon.clock, size: 15, color: Colors.deepOrange),Text(widget.tasks[index].remindTime!),const SizedBox(width: 10),
      //                         ],
      //                       ) : const Text(''),
      //                       Icon(TaskIcon.calendar_alt, color: widget.title == 'Earlier' ? Colors.deepOrange : Colors.black, size: 15,),
      //                       Text(widget.tasks[index].date!, style: TextStyle(fontSize: 13, color: widget.title == 'Earlier' ? Colors.red : Colors.black),),
      //                     ],
      //                   ),
      //                 ),
      //                 leading: IconButton(icon: widget.tasks[index].state! ? Container(
      //                     decoration: const BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: Colors.grey,
      //                     ),
      //                     child: const Icon(TaskIcon.done, color: Colors.white, size: 20)) : const Icon(Icons.circle_outlined), onPressed: () {
      //                   context.read<TaskState>().changeState(widget.tasks[index]);
      //                 }),
      //                 trailing: EditDelete(task: widget.tasks[index]),
      //               ),
      //             ))
      //     ),
      //   ],
      // ),
    // );
  }
}
