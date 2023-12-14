import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Test()
    )
  ));
}
class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test>  with SingleTickerProviderStateMixin{
  late final AnimationController controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
  late Animation<double> animation;
  @override
  void initState() {
    animation = Tween<double>(begin: 0, end: 100).animate(controller)
    ..addListener(() {
      setState(() {});
    })
    ..addStatusListener((status) {
      print(status);
    });
    controller.repeat();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: animation.value,
      height: animation.value,
    );

  }
}
