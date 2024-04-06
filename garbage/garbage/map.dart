
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:stravaclone/clean_architecture/features/presentation/pages/map/widgets/spotify.dart';
import 'package:stravaclone/font/weather.dart';
import 'package:stravaclone/clean_architecture/features/presentation/pages/map/widgets/weather.dart';
import '../clean_architecture/core/font/spotify.dart';
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
    return currentLocation == null ? const Scaffold(body : Center(child: CircularProgressIndicator())) :
      SafeArea(child: Scaffold(
        appBar: AppBar(
          title: const Center(child : Text('Run')),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(onPressed: () {},
                icon: const Icon(Icons.settings))
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
                    setState(() {});
                  } else {
                    _currentMapType = MapType.hybrid;
                    setState(() {});
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const Text('Distance (km)'),
                              Text(dis.substring(0, dis.length-3),
                                  style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const VerticalDivider(color : Colors.grey, ),
                        Center(
                          child: Column(
                            children: [
                              const Text('Pace (km/h)'),
                              Text((value != null) ? (double.parse(dis.substring(0, dis.length-3)) / ((double.parse(value.toString())) / (1000 * 3600))).toStringAsFixed(2) : '0.00',
                                  style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(color : Colors.grey),
                    Column(
                      children: [
                        const Text('Time',),
                        Text(displayTime.substring(0, 8),
                          style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color : Colors.grey),
                    Center(
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    elevation: 3,
                                    context: context,
                                    builder: (context) {
                                      return  const SizedBox(
                                          height: 300,
                                          child: SpotifyAPI());
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                fixedSize: const Size(60, 60),
                                shape: const CircleBorder()
                              ),
                              child: const Icon(Spotify.spotify, size: 40),
                          ),

                          !exchange ? ElevatedButton(onPressed: ()  async {
                            if (!start) {
                              timeClock.onStartTimer();
                              setState(() {
                                start = true;
                                stop = true;
                              });
                            } else {
                              timeClock.onStopTimer();
                              exchange = true;
                              stop = false;
                              setState(() {});
                            }

                          },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  fixedSize: const Size(80, 80),
                                  backgroundColor: Colors.deepOrange,
                                  shadowColor: Colors.lightBlueAccent
                              )
                              , child: !start ? const Text('START',
                                style: TextStyle(
                                    fontSize: 13
                                ),) :
                              const Icon(Icons.stop, size: 20,)
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(onPressed: () {
                                exchange = false;
                                timeClock.onStartTimer();
                                stop = true;
                              },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    fixedSize: const Size(80, 80),
                                    backgroundColor: Colors.deepOrange,
                                    shadowColor: Colors.lightBlueAccent
                                ),
                                child : const Text('RESUME',
                                  style: TextStyle(
                                      fontSize: 12
                                  ),),),
                              ElevatedButton(onPressed: () {
                                showDialog(context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Do you wanna save this acitivity ?'),
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
                                          }, child: const Text('Yes')),
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                            List<String> list = ['unvalid'];
                                            List<GeoPoint> path = [const GeoPoint(0, 0)];
                                            final user = <String, dynamic>{'distance' : 'unvalid', 'speed' : 'unvalid', 'path' : path, 'timeISO' : list};
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text(
                                                    'UnSaved',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                )));
                                            Navigator.pop(context, user);
                                          }, child: const Text('No'))
                                        ],
                                      );
                                    });
                              },
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      fixedSize: const Size(80, 80),
                                      backgroundColor: Colors.deepOrange,
                                      shadowColor: Colors.lightBlueAccent
                                  ),
                                  child : const Text('FINISH',
                                    style: TextStyle(
                                        fontSize: 14
                                    ),)),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  fixedSize: const Size(60, 60),
                                  shape: const CircleBorder()
                              ),
                              onPressed: () async{
                                Widget weather = await weatherAPI(currentLocation);
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.lightGreen,
                                        body :  weather,
                                      );
                                    });
                              },
                              child: const Icon(weather.cloud_sun_inv, size: 40,))
                        ],
                      )
                    )
                  ],
                ),
              );
            },
          )
          )
        ));
    
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