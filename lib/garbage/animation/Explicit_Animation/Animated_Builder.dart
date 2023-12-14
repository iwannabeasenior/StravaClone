
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: LearnAnimatedBuilder(),
    )
  ));
}
class LearnAnimatedBuilder extends StatefulWidget {
  const LearnAnimatedBuilder({super.key});

  @override
  State<LearnAnimatedBuilder> createState() => _LearnAnimatedBuilderState();
}

class _LearnAnimatedBuilderState extends State<LearnAnimatedBuilder> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    // TODO: implement initState
    curve = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    alpha = Tween<double>(begin: 0,  end: 3).animate(curve);
    controller.repeat();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  late AnimationController controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
  late Animation<double> curve;
  late Animation<double> alpha;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: alpha,
        builder: (BuildContext context, Widget? child) {
          return Center(
            widthFactor: alpha.value,
            heightFactor: alpha.value,
            child: child
          );
        },
        child: Container(color: Colors.purple, height: 200, width: 200));
  }
}
