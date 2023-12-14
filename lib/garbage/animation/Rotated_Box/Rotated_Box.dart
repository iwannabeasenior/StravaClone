import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Rotated_Box()
    )
  ));
}
class Rotated_Box extends StatefulWidget {
  const Rotated_Box({super.key});

  @override
  State<Rotated_Box> createState() => _Rotated_BoxState();
}

class _Rotated_BoxState extends State<Rotated_Box> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 2,
        child: Container(color: Colors.pink, height: 50, width: 200,),
    );
  }
}

