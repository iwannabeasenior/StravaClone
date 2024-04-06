import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(
    home: HomePage()
  ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(height: 300, width: 300, color: Colors.blue),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.open_in_browser_rounded),
      )
    );
  }
}

