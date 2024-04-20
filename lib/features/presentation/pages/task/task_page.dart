import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/domain/entity/task.dart';
import 'package:stravaclone/features/presentation/state/task_state.dart';
import 'package:stravaclone/features/presentation/pages/task/widget/task_planned.dart';
import 'package:stravaclone/features/presentation/pages/task/widget/task_task.dart';
import 'package:stravaclone/features/presentation/pages/task/widget/task_today.dart';
import 'package:stravaclone/helper/font/task_icon.dart';

import '../../../../helper/utility.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/usecase/get_data_task.dart';

class TaskFather extends StatelessWidget {
  const TaskFather({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TaskState(api: context.read<GetDataTask>()),
        child: const TaskPage()
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskState>(context, listen: false).loadTask();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var api = context.watch<TaskState>();
    return SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: api.color,
            appBar: AppBar(
              centerTitle: true,
              title: Text(api.currentPage.name, style: const TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_outlined, color: Colors.black,)
              ),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                        // request focus, avoid focus on textformfield
                        FocusScope.of(context).requestFocus(FocusNode());
                      },);
                  }
                )
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Flexible(
                      child: Container(color: Colors.lightBlueAccent,child: const Text('Today'))),
                  const Flexible(child: Text('Planned'))
                ],
              ),
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  Flexible(
                      child: InkWell(
                        onTap: () {
                          if (api.currentPage != CurrentPage.Today) {
                            api.color = Colors.yellow;
                            api.changeCurrentPage(CurrentPage.Today);
                          }
                        },
                        child: Container(
                            height: 100,
                            width: double.infinity,
                            color: api.currentPage == CurrentPage.Today ? Colors.deepOrange : Colors.white,
                            child: Center(child: Text('Today', style: TextStyle(color: api.currentPage == CurrentPage.Today ? Colors.white : Colors.black),))
                        ),
                      )
                  ),
                  Flexible(
                      child: InkWell(
                        onTap: () {
                          if (api.currentPage != CurrentPage.Planned) {
                            api.color = Colors.lightGreenAccent;
                            api.changeCurrentPage(CurrentPage.Planned);
                          }
                        },
                        child: Container(
                            height: 100,
                            width: double.infinity,
                            color: api.currentPage == CurrentPage.Planned ? Colors.deepOrange : Colors.white,
                            child: Center(child: Text('Planned', style: TextStyle(color: api.currentPage == CurrentPage.Planned ? Colors.white : Colors.black),))
                        ),
                      )
                  ),
                  Flexible(
                      child: InkWell(
                        onTap: () {
                          if (api.currentPage != CurrentPage.Task) {
                            api.color = Colors.deepPurple;
                            api.changeCurrentPage(CurrentPage.Task);
                          }
                        },
                        child: Container(
                            height: 100,
                            width: double.infinity,
                            color: api.currentPage == CurrentPage.Task ? Colors.deepOrange : Colors.white,
                            child: Center(child: Text('Task', style: TextStyle(color: api.currentPage == CurrentPage.Task ? Colors.white : Colors.black),))
                        ),
                      )
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: height * 0.03),
                Expanded(
                  flex: 7,
                  child: api.currentPage == CurrentPage.Today ? ListView(
                    children: [
                      for (var task in api.tasks) if (task.date == DateTime.now().toString().substring(0, 11) && task.state == false) ItemToday(task: task),
                      ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        title: Text('Completed'),
                        subtitle: Text(api.tasks.length.toString(), style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),),
                        children: [
                          for (var task in api.tasks) if (task.date == DateTime.now().toString().substring(0, 11) && task.state == true) ItemToday(task: task)
                        ],
                      )

                    ],
                  ) : api.currentPage == CurrentPage.Planned ?  buildTaskPlanned(api.tasks)
                      : ListView(
                              children: [
                                for (var task in api.tasks)
                                  if (task.state == false) ItemTask(task: task),
                                ExpansionTile(
                                    collapsedBackgroundColor: Colors.white,
                                    subtitle: Text(api.tasks.length.toString(), style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),),
                                    title: Text('Completed', style: TextStyle(color: Colors.white),),
                                    children: [
                                      for (var task in api.tasks)
                                        if (task.state == true)
                                          ItemTask(task: task)
                                    ]),
                              ],
                            )
                ),
                Expanded(
                  flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [Colors.blue.withOpacity(0.3), Colors.blue],
                          begin: Alignment.topCenter,
                        )
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            controller: controller,

                            onFieldSubmitted: (value) {
                              if (value.trim() != '') {
                                //save and clear
                                api.addTask(TaskModel(title: value.trim(), date: api.selectedDateTime.toString().substring(0, 11), state: false, remindTime: Utility.formatTime(api.selectedTimeOfDay)));
                              }
                              api.changeFocus(false);
                              controller.clear();
                            },
                            onChanged: (value) {
                              if (value.trim() != '') {
                                if (!api.isFocus) {
                                  api.changeFocus(true);
                                }
                              } else {
                                api.changeFocus(false);
                              }
                            },
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.add),
                              hintText: 'Add a task',
                              border: InputBorder.none,
                              suffixIcon: api.isFocus ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      final DateTime? selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: api.selectedDateTime ?? DateTime.now(),
                                        firstDate: DateTime(1000, 10, 10),
                                        lastDate: DateTime(2030, 30, 1),
                                      );
                                      if (selectedDate != null) {
                                        api.selectedDateTime = selectedDate;
                                      }
                                    },
                                    child: const Icon(TaskIcon.calendar_alt),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                      onLongPress: () {
                                        api.resetSelectedTimeOfDay();
                                      },
                                      onTap: () async {
                                        final TimeOfDay? selectedTime = await showTimePicker(
                                            context: context,
                                            initialTime: api.selectedTimeOfDay ?? TimeOfDay.now()
                                        );
                                        if (selectedTime != null) {
                                          api.selectedTimeOfDay = selectedTime;
                                        }
                                      },
                                      child: api.selectedTimeOfDay == null ? const Icon(TaskIcon.clock, color: Colors.grey) : const Icon(TaskIcon.clock, color: Colors.deepOrange,)),
                                  const SizedBox(width: 10,),
                                ],
                              ) : null ,
                              suffixText: api.isFocus ?  context.read<TaskState>().selectedDateTime?.toString().substring(0, 11) ?? '' : null,
                              suffixStyle: const TextStyle(fontSize: 12)
                            ),
                          ),
                        ),
                      )
                    )
                )
              ],
            )
          ),
        )
    );
  }
  Widget buildTaskPlanned(List<Task> tasks) {
    Map<String, List<Task>> portionTask = {};
    for (var task in tasks) {
      if (!task.state!) {
        if (portionTask[task.date!] != null) {
          portionTask[task.date!]!.add(task);
        } else {
          portionTask[task.date!] = [task];
        }
      }
    }
    Map<String, List<Task>> sortedTask;
    List<String> sortDate = portionTask.keys.toList();
    sortDate.sort((a, b) => DateTime.parse('${a}23:59:59').isAfter(DateTime.parse('${b}23:59:59')) ? 1 : -1);
    sortedTask = { for (var key in sortDate) key : portionTask[key]! };
    //
    Map<String, List<Task>> newSortedTask = {};
    for (var entry in sortedTask.entries) {
      if (DateTime.parse('${entry.key}23:59:59').isBefore(DateTime.now())) {
        // add to Erlier
        if (newSortedTask['Earlier'] != null) {
          newSortedTask['Earlier']?.addAll(entry.value);
        } else {
          newSortedTask['Earlier'] = entry.value;
        }
      } else if (entry.key == DateTime.now().toString().substring(0, 11)){
        newSortedTask['Today'] = entry.value;
      } else if (entry.key == DateTime.now().add(const Duration(days: 1)).toString().substring(0, 11)) {
        newSortedTask['Tomorrow'] = entry.value;
      } else {
        newSortedTask[entry.key] = entry.value;
      }
    }

    // sort
    return ListView.builder(
        itemCount: newSortedTask.length,
        itemBuilder: (context, index) => ItemPlanned(title: newSortedTask.entries.toList()[index].key, tasks: newSortedTask.entries.toList()[index].value,)
    );

  }
}



