
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  bool granted = false;
  final Set<Polyline> _polyline = {};
  MapType _currentMapType = MapType.normal;
  late GoogleMapController controllerMap;
  final timeClock = StopWatchTimer();
  String dis  = '0.00 km';
  bool start = false;
  bool exchange = false;
  bool stop = false;
  double zoom = 20;
  DistanceCalculator distance = DistanceCalculator();
  final List<LatLng> points = [];
  final List<String> timeIso = [];
  final List<String> times = [];
  LatLng? currentLocation;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _db = FirebaseFirestore.instance;
  @override
  void initState()  {
    super.initState();
    checkPermision();
    _polyline.add(
      Polyline(
        polylineId: const PolylineId('A'),
        points: points,
        color: Colors.red,
      )
    );
  }
  @override
  void dispose() {
    super.dispose();
    controllerMap.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return currentLocation == null ? const Scaffold(body : Center(child: Text('Waiting for creating map...', textAlign: TextAlign.center,))) :
      Scaffold(
        appBar: AppBar(
          title: Center(child : Text('Run')),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(onPressed: () {},
                icon: Icon(Icons.settings))
          ],
        ),
        body : Stack(
          children: [
            GoogleMap(
              initialCameraPosition:  CameraPosition(
                  zoom: zoom,
                  target: currentLocation!),
              markers: { Marker(
                position: currentLocation!,
                markerId: const MarkerId("currentLocation"),
                icon : BitmapDescriptor.defaultMarker,
              ),},
              circles: {
                const Circle(circleId: CircleId(AutofillHints.addressCity))
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              buildingsEnabled: true,
              zoomControlsEnabled: true,
              myLocationEnabled:  true,
              mapType: _currentMapType,
              polylines: _polyline,
              compassEnabled: true,
              onCameraMove: (CameraPosition cameraPosition) {
                zoom = cameraPosition.zoom;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child : PopupMenuButton(
                child : const Icon(Icons.layers, size: 50, color: Colors.black38),
                onSelected: (value) {
                  if (value == TypeMap.Standard) {
                    _currentMapType = MapType.normal;
                    setState(() {

                    });
                  } else if (value == TypeMap.Satellite) {
                    _currentMapType = MapType.satellite;
                    setState(() {

                    });
                  } else {
                    _currentMapType = MapType.hybrid;
                    setState(() {

                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                      value : TypeMap.Standard,
                      child: Text('Standard')
                  ),
                  PopupMenuItem(
                      value : TypeMap.Satellite,
                      child: Text('Satellite')
                  ),
                  PopupMenuItem(
                      value : TypeMap.Hybrid,
                      child: Text('Hybrid')
                  )
                ]
              )
            ),

          ],
        ),


        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 300,
            child : StreamBuilder(
            stream: timeClock.rawTime ,
            builder: (context, snap) {
              final value = snap.data;
              final displayTime = (value != null) ? StopWatchTimer.getDisplayTime(value) : '00:00:00';

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.all(2),
                    //       child: Container(
                    //         color: Colors.lightGreenAccent,
                    //         height: 20,
                    //         child: Text(
                    //             'Time : ${displayTime.substring(0, 8)}',
                    //             style : const TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 15
                    //             )
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: 20,
                    //       color: Colors.lightGreenAccent,
                    //       child: Text(
                    //         'Distance : $dis',
                    //         style: const TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15,
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       color : Colors.lightGreenAccent,
                    //       height: 20,
                    //       child: Text(
                    //           (value != null) ? 'Speed : ${(double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value!.toString())) / (1000 * 3600))).toStringAsFixed(2)} km/h' : 'Speed : 0.00 km/h',
                    //           style: const TextStyle(
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.bold
                    //           )
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text('Distance (km)'),
                              Text(dis.substring(0, dis.length-3),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        VerticalDivider(color : Colors.grey, ),
                        Center(
                          child: Column(
                            children: [
                              Text('Pace (km/h)'),
                              Text((value != null) ? (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value!.toString())) / (1000 * 3600))).toStringAsFixed(2) : '0.00',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(color : Colors.grey),
                    Column(
                      children: [
                        Text('Time',),
                        Text(displayTime.substring(0, 8),
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(color : Colors.grey),
                    Center(
                      child: !exchange ? ElevatedButton(onPressed: ()  async {
                        if (!start) {
                          timeClock.onStartTimer();
                          // Navigator.push(context, MaterialPageRoute(
                          //     builder: (context) {
                          //       timeClock.onStartTimer();
                          //       return StreamBuilder(stream: timeClock.rawTime,
                          //           builder: (context, snap) {
                          //             final displayTime1 = StopWatchTimer.getDisplayTime(snap.data!);
                          //             return Scaffold(
                          //                 body : Column(
                          //                   children: [
                          //                     Expanded(
                          //                         flex : 1,
                          //                         child: Container(
                          //                           padding: EdgeInsets.all(2),
                          //                           child: Center(
                          //                             child:  Column(
                          //                               children: [
                          //                                 SizedBox(height: 20,),
                          //                                 Text('Time : ',
                          //                                   style: TextStyle(
                          //                                       fontSize: 30
                          //                                   ),),
                          //                                 Text(displayTime1.substring(0, 8),
                          //                                     style: TextStyle(
                          //                                       fontSize: 90,
                          //                                       fontWeight: FontWeight.bold,
                          //                                     )
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         )
                          //                     ),
                          //                     Divider(
                          //                       color : Colors.black,
                          //                     ),
                          //                     Expanded(
                          //                         flex : 1,
                          //                         child: Container(
                          //                           padding: EdgeInsets.all(2),
                          //                           child:   Column(
                          //                             children: [
                          //                               SizedBox(height: 20),
                          //                               Text('Time : ',
                          //                                 style: TextStyle(
                          //                                   fontSize: 30,
                          //                                 ),),
                          //                               Text(displayTime1.substring(0, 8),
                          //                                   style: TextStyle(
                          //                                     fontSize: 90,
                          //                                     fontWeight: FontWeight.bold,
                          //                                   )
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         )
                          //                     ),
                          //                     Divider(
                          //                       color : Colors.black,
                          //                     ),
                          //                     Expanded(
                          //                         flex : 1,
                          //                         child: Container(
                          //                           padding: EdgeInsets.all(2),
                          //                           child:   Column(
                          //                             children: [
                          //                               SizedBox(height : 20),
                          //                               Text('Time : ',
                          //                                   style: TextStyle(
                          //                                       fontSize: 30
                          //                                   )),
                          //                               Text(displayTime1.substring(0, 8),
                          //                                   style: TextStyle(
                          //                                     fontSize: 90,
                          //                                     fontWeight: FontWeight.bold,
                          //                                   )
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         )
                          //                     ),
                          //                     Divider(
                          //                       color : Colors.black,
                          //                     ),
                          //                     Expanded(
                          //                         flex: 1,
                          //                         child: Row(
                          //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //                           children: [
                          //                             ElevatedButton(onPressed: () {
                          //
                          //                             },
                          //                               child: Icon(Icons.map),
                          //                               style: ElevatedButton.styleFrom(
                          //                                 backgroundColor: Colors.deepOrange,
                          //                                 shape: CircleBorder(),
                          //                                 fixedSize: Size(70, 70),
                          //                               ),
                          //                             ),
                          //                             ElevatedButton(onPressed: () {
                          //                               if (timeClock.isRunning) {
                          //                                 timeClock.onStopTimer();
                          //                                 setState(() {
                          //
                          //                                 });
                          //                               } else {
                          //                                 timeClock.onStartTimer();
                          //                                 setState(() {
                          //
                          //                                 });
                          //                               }
                          //                             },
                          //                               child: timeClock.isRunning ? Icon(Icons.stop, size: 40) : Icon(Icons.play_arrow, size : 40),
                          //                               style: ElevatedButton.styleFrom(
                          //                                 fixedSize: Size(70, 70),
                          //                                 shape: CircleBorder(),
                          //                                 backgroundColor: Colors.deepOrange,
                          //                               ),
                          //                             ),
                          //                             ElevatedButton(
                          //                               onPressed: () {
                          //
                          //                               } ,
                          //                               child: Icon(Icons.wifi),
                          //                               style: ElevatedButton.styleFrom(
                          //                                 fixedSize: Size(70, 70),
                          //                                 shape: BeveledRectangleBorder(),
                          //                               ),
                          //                             ),
                          //                             ElevatedButton(
                          //                               onPressed: () {
                          //                                 // Hiển thị trang trượt lên khi nút được nhấn
                          //                                 showModalBottomSheet(
                          //                                   isScrollControlled: true,
                          //                                   context: context,
                          //                                   builder: (BuildContext context) {
                          //                                     return MyBottomSheetContent();
                          //                                   },
                          //                                 );
                          //                               },
                          //                               child: Text('Mở trang trượt lên'),
                          //                             ),
                          //                           ],
                          //                         )
                          //                     ),
                          //                   ],
                          //                 )
                          //             );
                          //           });
                          //           })
                          //     );
                          setState(() {
                            start = true;
                            stop = true;
                          });
                        } else {
                          timeClock.onStopTimer();
                          exchange = true;
                          stop = false;
                          setState(() {

                          });
                          // start = false;
                          // List<GeoPoint> path = [];
                          // for (LatLng latlng in points) {
                          //   path.add(GeoPoint(latlng.latitude, latlng.longitude));
                          // }
                          // final user = <String, dynamic>{'distance' : dis, 'speed' : (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2) , 'time' : displayTime.substring(0, 8), 'path' : path, 'timeISO' : timeIso};
                          // if (timeIso.isNotEmpty) {
                          //   await _db.collection('information').add(user);
                          // }
                          // Navigator.pop(context, user);

                        }

                      },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          fixedSize: Size(80, 80),
                          backgroundColor: Colors.deepOrange,
                          shadowColor: Colors.lightBlueAccent
                        )
                        , child: !start ? Text('START',
                          style: TextStyle(
                            fontSize: 13
                          ),) :
                              Icon(Icons.stop, size: 20,)
                    )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(onPressed: () {
                                  exchange = false;
                                  timeClock.onStartTimer();
                                  stop = true;
                                },
                                  child : Text('RESUME',
                                    style: TextStyle(
                                        fontSize: 12
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      fixedSize: Size(80, 80),
                                      backgroundColor: Colors.deepOrange,
                                      shadowColor: Colors.lightBlueAccent
                                  ),),
                                ElevatedButton(onPressed: () {
                                  showDialog(context: context,
                                      builder: (context) {
                                          return AlertDialog(
                                            title: Text('Do you wanna save this acitivity ?'),
                                            actions: [
                                              TextButton(onPressed: () async {
                                                List<GeoPoint> path = [];
                                                for (LatLng latlng in points) {
                                                  path.add(GeoPoint(latlng.latitude, latlng.longitude));
                                                }
                                                final user = <String, dynamic>{'distance' : dis, 'speed' : (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2) , 'time' : displayTime.substring(0, 8), 'path' : path, 'timeISO' : timeIso};
                                                if (timeIso.isNotEmpty) {
                                                  await _db.collection('information').add(user);
                                                }
                                                Navigator.pop(context);
                                                Navigator.pop(context, user);
                                              }, child: Text('Yes')),
                                              TextButton(onPressed: () {
                                                Navigator.pop(context);
                                                List<String> list = [];
                                                List<GeoPoint> path = [];
                                                final user = <String, dynamic>{'distance' : 'unvalid', 'speed' : 'unvalid', 'path' : path, 'timeISO' : list};
                                                Navigator.pop(context, user);
                                              }, child: Text('No'))
                                            ],
                                          );
                                      });
                                },
                                    child : Text('FINISH',
                                      style: TextStyle(
                                          fontSize: 14
                                      ),),
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        fixedSize: Size(80, 80),
                                        backgroundColor: Colors.deepOrange,
                                        shadowColor: Colors.lightBlueAccent
                                    )),
                        ],
                      )
                      ,)
                  ],
                ),
              );
            },
          )
          )
        );
    
  }

  Future<void> cameraPositionChange(LatLng pos) async {
    if (!granted) {
      controllerMap = await _controller.future;
      granted = true;
    }
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom : zoom);
    await controllerMap.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> checkPermision() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return ;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return ;
      }
    }

    locationData = await location.getLocation().then(
        (value) {
           currentLocation = LatLng(value.latitude!, value.longitude!);
           setState(() {
           });
           return value;
        }
    );

    location.onLocationChanged.listen((LocationData locationData) async {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        if (stop) {
          points.add(currentLocation!);
          timeIso.add('${DateTime.now().toUtc().toIso8601String().substring(0, 19)}Z');
          _polyline.add(
              Polyline(
                polylineId: const PolylineId('A'),
                points: points,
                color: Colors.red,
              )
          );
          dis = distance.calculateRouteDistance(points, decimals: 2);
        }
       await cameraPositionChange(currentLocation!);
      setState(() {});
    });
  }
}

enum TypeMap {
  Standard, Satellite, Hybrid;
}