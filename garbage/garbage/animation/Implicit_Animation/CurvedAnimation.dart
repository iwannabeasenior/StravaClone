import 'dart:math';

import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(

    home: Scaffold(
      body: Curved_Animation()
    ),
  ));
}
class MyCurve extends Curve {
  // t : time (Ox), return (Oy)
  @override
  double transform(double t) {
    return sin(t);
  }
}
class Curved_Animation extends StatefulWidget {
  const Curved_Animation({super.key});

  @override
  State<Curved_Animation> createState() => _Curved_AnimationState();
}

class _Curved_AnimationState extends State<Curved_Animation> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(duration: const Duration(seconds: 2), vsync: this) ..repeat();
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 200),
        duration: const Duration(seconds: 2),
        builder: (context, double? value , child) {
          return Container(
            height: value,
            width: value,
            color: Colors.pink,
            child: child,

          );
        },
      curve: MyCurve(),
      onEnd: () {

      },
      child: const Text(
        'To len',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 100,
        ),
      ),
    );
  }
}

