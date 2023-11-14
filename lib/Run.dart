
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'garbage/slidefrombottom.dart';
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
        final displayTime = (value != null ) ? StopWatchTimer.getDisplayTime(value!) :  '00:00:00' ;
        return Scaffold(
          body : Column(
            children: [
              Expanded(
                flex : 1,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    child: Center(
                      child:  Column(
                        children: [
                          SizedBox(height: 20,),
                          Text('Time : ',
                          style: TextStyle(
                            fontSize: 30
                          ),),
                          Text(displayTime.substring(0, 8),
                          style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            )
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex : 1,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    child:   Column(
                      children: [
                        SizedBox(height: 20),
                        Text('Time : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),),
                        Text(displayTime.substring(0, 8),
                            style: TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                  )
              ),
              Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex : 1,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    child:   Column(
                      children: [
                        SizedBox(height : 20),
                        Text('Time : ',
                        style: TextStyle(
                          fontSize: 30
                        )),
                        Text(displayTime.substring(0, 8),
                            style: TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                  )
              ),
              Divider(
                color : Colors.black,
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {

                      },
                          child: Icon(Icons.map),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: CircleBorder(),
                            fixedSize: Size(70, 70),
                          ),
                      ),
                      ElevatedButton(onPressed: () {
                        if (timer.isRunning) {
                          timer.onStopTimer();
                        } else {
                          timer.onStartTimer();
                        }
                      },
                          child: timer.isRunning ? Icon(Icons.stop, size: 40) : Icon(Icons.play_arrow, size : 40),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(70, 70),
                            shape: CircleBorder(),
                            backgroundColor: Colors.deepOrange,
                          ),
                      ),
                      ElevatedButton(
                          onPressed: () {

                          } ,
                          child: Icon(Icons.wifi),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(70, 70),
                            shape: BeveledRectangleBorder(),
                          ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Hiển thị trang trượt lên khi nút được nhấn
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return MyBottomSheetContent();
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