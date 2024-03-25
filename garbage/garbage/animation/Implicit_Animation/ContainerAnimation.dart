import 'package:flutter/material.dart';
void main() {
  runApp(
      const MaterialApp(
        home: Home()
      ));
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color color = Colors.white;
  double _margin = 20;
  double _height = 1000;
  double _opacity = 1;
  double _padding = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        // curve: Curves.bounceIn,
        duration: const Duration(milliseconds: 500),
        color: color,
        height: _height,
        padding: EdgeInsets.all(_padding),
        margin: EdgeInsets.all(_margin),
        child: ListView(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _margin = 100;
                  });
                },
                child: const Text('Change margin')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _padding = 100;
                  });
                },
                child: const Text('Change padding')),
            TextButton(
                onPressed: () {
                  setState(() {
                    color = Colors.purple;
                  });

                },
                child: const Text('Change color')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _height = 500;
                  });
                },
                child: const Text('Change height')),
            AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 900),
                child: const Text('Text will disappear when you click button below'),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _opacity = 0;
                  });
                },
                child: const Text('Change opacity of text, container not have opacity'))
          ],
        )
      )
    );
  }
}
