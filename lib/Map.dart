
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'firebase_options.dart';
import 'home.dart';

class MyMap extends StatefulWidget {
  MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  MapType _currentMapType = MapType.normal;
  late GoogleMapController controllerMap;
  final timeclock = StopWatchTimer();
  String dis  = '0.00 km';
  String speed = '0';
  bool start = false;
  DistanceCalculator distance = DistanceCalculator();
  List<LatLng> points = [];
  LatLng? currentLocation = null;
  MapsRoutes routes = MapsRoutes();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    checkPermision();
    // draw();
  }
  Future<void> draw() async {
    await routes.drawRoute(points, "RouteMap", Colors.red, "AIzaSyA3U7GWwoEJdgdIAoKU-CRejRmDR0z1Pac", travelMode : TravelModes.bicycling);
  }
  @override
  Widget build(BuildContext context) {
    return currentLocation == null ? const Center(child: Text('nothing to show')) :
       Scaffold(
        body : Stack(
          children: [
            GoogleMap(
              initialCameraPosition:  CameraPosition(
                  zoom: 15,
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
              // polylines: routes.routes
            ),
            Align(
              alignment: Alignment.centerRight,
              child : PopupMenuButton(
                child : Icon(Icons.layers, size: 50, color: Colors.black38),
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
                      child: Text('Standard'),
                      value : TypeMap.Standard
                  ),
                  PopupMenuItem(
                      child: Text('Satellite'),
                      value : TypeMap.Satellite
                  ),
                  PopupMenuItem(
                      child: Text('Hybrid'),
                      value : TypeMap.Hybrid
                  )
                ]
              )
            ),

          ],
        ),


        bottomNavigationBar: BottomAppBar(
          height: 200,
            child : StreamBuilder(
            stream: timeclock.rawTime ,
            builder: (context, snap) {
              final value = snap.data;
              final displayTime = StopWatchTimer.getDisplayTime(value!);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Text(
                              displayTime,
                              style : TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              )
                          ),
                        ),
                        Text(
                          dis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                            '${(double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2)} km/h',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                    ),

                    Center(
                      child: ElevatedButton(onPressed: ()  async {
                        if (!start) {
                          timeclock.onStartTimer();
                          setState(() {
                            start = true;
                          });
                        } else {
                          timeclock.onStopTimer();
                          start = false;
                          final user = <String, dynamic>{'distance' : dis, 'speed' : (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2) , 'time' : displayTime};
                          await _db.collection('information').add(user);
                          Navigator.pop(context, user);
                        }

                      }, child: Icon(start ? Icons.stop : Icons.not_started_outlined )),
                    ),

                  ],
                ),
              );
            },
          )
          )
        );
    
  }

  Future<void> cameraPositionChange(LatLng pos) async {

    controllerMap = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom : 15);
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
    locationData = await location.getLocation();

    location.onLocationChanged.listen((LocationData locationData) async {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        if (start) {
          points.add(currentLocation!);
          await routes.drawRoute(points, "RouteMap", Colors.red, "AIzaSyA3U7GWwoEJdgdIAoKU-CRejRmDR0z1Pac");
          dis = distance.calculateRouteDistance(points, decimals: 2);
        }
      if (_controller.isCompleted) await cameraPositionChange(currentLocation!);
      setState(() {});
    });
  }
}

enum TypeMap {
  Standard, Satellite, Hybrid;
}