import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool start = false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
              children: [
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value!);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(onPressed: () {
                  if (!start) {
                    _stopWatchTimer.onStartTimer();
                    setState(() {
                      start = true;
                    });
                  } else {
                    _stopWatchTimer.onStopTimer();
                    setState(() {
                      start = false;
                    });
                  }

                }, child: Icon(start ? Icons.stop : Icons.not_started_outlined ))
              ],
            )
        ),
      )
    );
  }
}

