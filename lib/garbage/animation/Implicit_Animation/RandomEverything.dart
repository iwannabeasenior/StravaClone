
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stravaclone/garbage/sized_icon_button.dart';
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: RandomEverything()
    )
  ));
}
class RandomEverything extends StatefulWidget {
  const RandomEverything({super.key});

  @override
  State<RandomEverything> createState() => _RandomEverythingState();
}

class _RandomEverythingState extends State<RandomEverything> {
  Random random = Random();
  late Color color;
  late double size;
  late BorderRadius borderRadius;
  void randomColor()  {

  }
  void randomSize() {
    size = random.nextDouble();
  }
  @override
  void initState() {
    color = Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
    size = random.nextDouble()*300;
    borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius
              ),
          ),
          SizedIconButton(
              width: 100,
              icon: Icons.change_circle,
              onPressed: () {
                color = Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
                size = random.nextDouble()*300;
                borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
                setState(() {});
              })
        ],
      ),
    );
  }
}
