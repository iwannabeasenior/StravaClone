import 'package:flutter/material.dart';

class UnknownPage extends StatefulWidget {
  const UnknownPage({super.key});

  @override
  State<UnknownPage> createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  @override
  Widget build(BuildContext context) {
    // var args = ModalRoute.of(context)!.settings.name;
    return const Scaffold(
      body: Center(child: Text('Unknown Page'))
    );
  }
}
