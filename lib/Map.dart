
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MyMap extends StatefulWidget {
  MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Set<Polyline> _polyline = {};
  MapType _currentMapType = MapType.normal;
  late GoogleMapController controllerMap;
  final timeclock = StopWatchTimer();
  String dis  = '0.00 km';
  bool start = false;
  DistanceCalculator distance = DistanceCalculator();
  final List<LatLng> points = [];
  LatLng currentLocation = LatLng(0, 0);
  MapsRoutes routes = MapsRoutes();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _db = FirebaseFirestore.instance;
  @override
  void initState()  {
    super.initState();
    checkPermision();
    _polyline.add(
      Polyline(
        polylineId: PolylineId('A'),
        points: points,
        color: Colors.red,
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return currentLocation == null ? const Scaffold(body : Center(child: Text('Waiting...', textAlign: TextAlign.center,))) :
       Scaffold(
        body : Stack(
          children: [
            GoogleMap(
              initialCameraPosition:  CameraPosition(
                  zoom: 30,
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
          color: Colors.amber,
          height: 200,
            child : StreamBuilder(
            stream: timeclock.rawTime ,
            builder: (context, snap) {
              final value = snap.data;
              final displayTime = (value != null) ? StopWatchTimer.getDisplayTime(value!) : '00:00:00';
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Container(
                            color: Colors.lightGreenAccent,
                            height: 20,
                            child: Text(
                                'Time : $displayTime',
                                style : TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                )
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          color: Colors.lightGreenAccent,
                          child: Text(
                            'Distance : $dis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          color : Colors.lightGreenAccent,
                          height: 20,
                          child: Text(
                              (value != null) ? 'Speed : ${(double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value!.toString())) / (1000 * 3600))).toStringAsFixed(2)} km/h' : 'Speed : 0.00 km/h',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
                          List<GeoPoint> path = [];
                          for (LatLng latlng in points) {
                            path.add(GeoPoint(latlng.latitude, latlng.longitude));
                          }
                          final user = <String, dynamic>{'distance' : dis, 'speed' : (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2) , 'time' : displayTime, 'path' : path};
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
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom : 30);
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
        if (start) {
          points.add(currentLocation!);
          _polyline.add(
              Polyline(
                polylineId: PolylineId('A'),
                points: points,
                color: Colors.red,
              )
          );
          // await routes.drawRoute(points, "RouteMap", Colors.red, "AIzaSyA3U7GWwoEJdgdIAoKU-CRejRmDR0z1Pac");
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