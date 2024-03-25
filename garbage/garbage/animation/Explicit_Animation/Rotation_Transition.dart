import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Rotation_Transition()
    )
  ));
}
class Rotation_Transition extends StatefulWidget {
  const Rotation_Transition({super.key});

  @override
  State<Rotation_Transition> createState() => _Rotation_TransitionState();
}

class _Rotation_TransitionState extends State<Rotation_Transition> with SingleTickerProviderStateMixin{
  late AnimationController controller = AnimationController(vsync: this, duration: const Duration(seconds: 2)) .. repeat();
  late CurvedAnimation animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc);
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        alignment: Alignment.bottomRight,
        filterQuality: FilterQuality.low,
        turns: animation,
        child: Container(
          height: 100,
          width: 100,
          color: Colors.red,
        )
    );
  }
}
