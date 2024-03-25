import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: Icon(Icons.ac_unit)),
          Expanded(flex: 3,child: Icon(Icons.add_alert_rounded),)
        ],
      ),
    )
  ));
}
