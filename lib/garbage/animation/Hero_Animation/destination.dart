import 'package:flutter/material.dart';
class Destination extends StatefulWidget {
  const Destination({super.key});

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: '12345',
      child: SizedBox(
        height: 300,
        width: 300,
        child: Image.network('https://cdn.hoanghamobile.com/tin-tuc/wp-content/uploads/2023/07/hinh-dep.jpg')
      ),
    );
  }
}
