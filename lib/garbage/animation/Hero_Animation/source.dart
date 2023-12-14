import 'package:flutter/material.dart';

import 'destination.dart';
void main() { 
  runApp(const MaterialApp(
    home: Scaffold(
      body: Source(),
    )
  ));
}
class Source extends StatefulWidget {
  const Source({super.key});

  @override
  State<Source> createState() => _SourceState();
}

class _SourceState extends State<Source> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                 return const Destination();
                }
            )
        );
      },
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: Hero(
            tag: '12345',
            transitionOnUserGestures: true,
            child: Image.network('https://cdn.hoanghamobile.com/tin-tuc/wp-content/uploads/2023/07/hinh-dep.jpg'),
          ),
        ),
      ),
    );
  }
}
