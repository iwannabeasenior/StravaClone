
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'slidefrombottom.dart';
void main() {
  runApp(MaterialApp(
    home : SafeArea(
      child : run(),
    )
  ));
}
Widget run() {
  StopWatchTimer timer = StopWatchTimer();
  return StreamBuilder(
      stream: timer.rawTime,
      builder: (context, snap) {
        final value = snap.data;
        final displayTime = (value != null ) ? StopWatchTimer.getDisplayTime(value) :  '00:00:00' ;
        return Scaffold(
          body : Column(
            children: [
              Expanded(
                flex : 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Center(
                      child:  Column(
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Time : ',
                          style: TextStyle(
                            fontSize: 30
                          ),),
                          Text(displayTime.substring(0, 8),
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            )
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              const Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex : 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child:   Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text('Time : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),),
                        Text(displayTime.substring(0, 8),
                            style: const TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                  )
              ),
              const Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex : 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child:   Column(
                      children: [
                        const SizedBox(height : 20),
                        const Text('Time : ',
                        style: TextStyle(
                          fontSize: 30
                        )),
                        Text(displayTime.substring(0, 8),
                            style: const TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                  )
              ),
              const Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {

                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: const CircleBorder(),
                            fixedSize: const Size(70, 70),
                          ),
                          child: const Icon(Icons.map),
                      ),
                      ElevatedButton(onPressed: () {
                        if (timer.isRunning) {
                          timer.onStopTimer();
                        } else {
                          timer.onStartTimer();
                        }
                      },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(70, 70),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.deepOrange,
                          ),
                          child: timer.isRunning ? const Icon(Icons.stop, size: 40) : const Icon(Icons.play_arrow, size : 40),
                      ),
                      ElevatedButton(
                          onPressed: () {

                          } ,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(70, 70),
                            shape: const BeveledRectangleBorder(),
                          ),
                          child: const Icon(Icons.wifi),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Hiển thị trang trượt lên khi nút được nhấn
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const MyBottomSheetContent();
                            },
                          );
                        },
                        child: const Text('Mở trang trượt lên'),
                      ),
                    ],
                  )
              ),
            ],
          )
        );
      });
}