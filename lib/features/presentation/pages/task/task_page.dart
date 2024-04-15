import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(home: TaskPage()));
}
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: height * 0.15,
                child: const Row(
                  children: [

                  ],
                )
              )
            ],
          )
        )
    );
  }
}
