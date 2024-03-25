import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(
      home: Scaffold(
          body: Transform_Rotate()
      )
  ));
}
class Transform_Rotate extends StatefulWidget {
  const Transform_Rotate({super.key});

  @override
  State<Transform_Rotate> createState() => _Transform_RotateState();
}

class _Transform_RotateState extends State<Transform_Rotate> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: 20,
        child: Container(height: 100, width: 200, color: Colors.pink),
    );
  }
}
