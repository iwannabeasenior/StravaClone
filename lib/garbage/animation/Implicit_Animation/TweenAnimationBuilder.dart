import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: LearnTween()
    )
  ));
}
class LearnTween extends StatefulWidget {
  const LearnTween({super.key});

  @override
  State<LearnTween> createState() => _LearnTweenState();
}

class _LearnTweenState extends State<LearnTween> {
  Color? endColor = Colors.black;
  // static final ColorTween tween = ColorTween(begin: Colors.white, end: endColor);
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        child : Container(height: 100, width: 100,),
        tween: ColorTween(begin: Colors.white, end: endColor) ,
        duration: Duration(milliseconds: 900),
        builder: (BuildContext _, Color? value, Widget? child) {

          return Container(
            child: child,
            color: value,
          );
        },
        curve: Curves.easeInBack, // bieu thi van toc thay doi theo thoi gian
        onEnd: () {
          setState(() {
            endColor == Colors.black ? endColor = Colors.purple : endColor = Colors.black;
          });
        },
    );
  }
}
