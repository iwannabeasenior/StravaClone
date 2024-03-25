import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
void main() {
  runApp(MaterialApp(
    home : Scaffold(
      body: const MyClock(),
      appBar: AppBar(
        title: const Center(
          child : Text('Clock',
          style: TextStyle(color: Colors.red,
          fontSize: 32,
          fontWeight: FontWeight.w100),)
        ),
      ),

    )
  ));
}
class MyClock extends StatefulWidget {
  const MyClock({super.key});

  @override
  State<MyClock> createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  final timeclock = StopWatchTimer();
  final timeclock2 = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(1),
  );
  bool start = false;
  @override
  Widget build(BuildContext context) {
    return
          StreamBuilder(
              stream: timeclock2.rawTime ,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style : const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                            )
                          ),
                      ),
                      ElevatedButton(onPressed: () {
                        if (!start) {
                          timeclock2.onStartTimer();
                          setState(() {
                            start = true;
                          });
                        } else {
                          timeclock2.onStopTimer();
                          setState(() {
                            start = false;
                          });
                        }

                      }, child: Icon(start ? Icons.stop : Icons.not_started_outlined )),
                      ElevatedButton(
                          onPressed: () {
                            timeclock2.onResetTimer();
                          },
                          child: const Icon(Icons.lock_reset))
                    ],
                  ),
                );
              },
          );
  }
}
