import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Row(
        children: [
          Expanded(child: Icon(Icons.ac_unit), flex: 1),
          Expanded(child: Icon(Icons.add_alert_rounded), flex: 3,)
        ],
      ),
    )
  ));
}
