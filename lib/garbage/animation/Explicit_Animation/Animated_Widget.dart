import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: LearnAnimatedWidget()
    )
  ));
}
class LearnAnimatedWidget extends StatefulWidget {
  const LearnAnimatedWidget({super.key});

  @override
  State<LearnAnimatedWidget> createState() => _LearnAnimatedWidgetState();
}

class _LearnAnimatedWidgetState extends State<LearnAnimatedWidget> with TickerProviderStateMixin{
  late AnimationController controller = AnimationController(duration: Duration(seconds: 2), vsync: this)..repeat();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SpinningContainer(controller: controller);
  }
}
class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({super.key, required AnimationController controller}) : super(listenable: controller);
  Animation<double> get progress => listenable as Animation<double>;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: progress.value,
        child: Container(color: Colors.purple, height: 200, width: 200,),
    );
  }
}

