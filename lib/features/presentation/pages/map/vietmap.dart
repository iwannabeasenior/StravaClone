import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/usecase/get_top_50_tracks.dart';
import 'package:stravaclone/features/domain/usecase/get_weather_today.dart';
import 'package:stravaclone/features/domain/usecase/get_work_out_album.dart';
import 'package:stravaclone/features/presentation/pages/map/widgets/spotify.dart';
import 'package:stravaclone/features/presentation/pages/map/widgets/strava.dart';
import 'package:stravaclone/features/presentation/pages/map/widgets/weather_api.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../../core/font/location.dart' as location;
import '../../../../core/font/spotify.dart';
import '../../../../core/font/weather.dart';
import '../../../data/models/post_model.dart';
import '../../../domain/entity/track.dart';
import '../../../domain/entity/weather.dart' as weather;
import '../../support/generate_gpx_file.dart';
import '../home/home_change_notifier.dart';

class MyMap extends StatefulWidget {
  HomeChangeNotifier home;
  MyMap({super.key, required this.home});
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  FlutterAppAuth appAuth = FlutterAppAuth();
  late SharedPreferences sharedPreferences;
  var accessToken;
  var refreshToken;
  var expiredAt;


  ScreenshotController screenshotController = ScreenshotController();
  late VietmapController controller;
  bool setZoom = false; // set zoom = 18 when map is created
  final timeClock = StopWatchTimer();
  double dis = 0.00;
  bool start = false; // or not user start running
  bool exchange = false; // change from stop to resume/end and reverse
  double zoom = 16; // save zoom of camera of map
  LatLng? currentLocation;

  final List<LatLng> pathsSon = [];
  final List<String> timeIsoSon = [];
  final List<double> altitudeSon = [];

  final List<LatLng> route = []; // save route for polyline
  final List<List<LatLng>> paths = [];
  final List<List<String>> timeIso = [];
  final List<List<double>> altitude = [];


  List<Track> tracks50 = [];
  List<Track> albumWorkOut = [];
  List<weather.Weather> hours = [];

  Logger log = Logger();

  @override
  void initState() {
    checkPermision();
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: TextButton(
                child: const Text(
                  'Hide',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                // color: Colors.deepOrange,
                onPressed: () {
                  widget.home.changeStateOpenMap();
                },
              ),
              title: const Center(
                  child: Text(
                'Run',
                style: TextStyle(color: Colors.black),
              )),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.deepOrange,
                    )
                )
              ],
            ),
            body: Stack(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: buildVietmapGL(timeClock),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () async {
                        final location =
                            await controller.requestMyLocationLatLng();
                        await controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: location!, zoom: zoom)));
                      },
                      icon: Container(
                        width: 300,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black54)],
                        ),
                        child: const Icon(
                          location.Location.my_location,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: (!timeClock.isRunning && start == true) ? 40 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      color: Colors.deepOrange,
                      height: 40,
                      width: double.infinity,
                      child: const Center(
                          child: Text(
                        'STOPPED',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2,
                child: StreamBuilder(
                  stream: timeClock.rawTime,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = (value != null)
                        ? StopWatchTimer.getDisplayTime(value)
                        : '00:00:00';

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text('DISTANCE (KM)'),
                                    const SizedBox(height: 5),
                                    Text(dis.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const VerticalDivider(
                                    width: 1,
                                    thickness: 0.5,
                                    color: Colors.grey,
                                    indent: 15,
                                    endIndent: 15),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text('PACE (KM/H)'),
                                    const SizedBox(height: 5),
                                    Text(
                                        (value != null)
                                            ? (dis /
                                                    ((double.parse(
                                                            value.toString())) /
                                                        (1000 * 3600)))
                                                .toStringAsFixed(2)
                                            : '0.00',
                                        style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          Column(
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'TIME',
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(displayTime.substring(0, 8),
                                  style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          SizedBox(
                            height: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.blue,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                          ),
                                          elevation: 10,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.6)]
                                                  )
                                                ),
                                                height: 500,
                                                child: tracks50.isEmpty ? FutureBuilder(
                                                    future: get50AndTopTracks(),
                                                    builder: (context, snapshot) {
                                                      switch(snapshot.connectionState) {
                                                        case ConnectionState.waiting : return  Center(child: CircularProgressIndicator());
                                                        default:
                                                          if (snapshot.hasError) {
                                                            log.d(snapshot.error);
                                                            return Text('nothing');
                                                          } else {
                                                            return SpotifyAPI(tracks50: tracks50, albumWorkOut: albumWorkOut);
                                                          }
                                                      }
                                                    }
                                                ) : SpotifyAPI(tracks50: tracks50, albumWorkOut: albumWorkOut,)
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Spotify.spotify,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  endIndent: 15,
                                  indent: 10,
                                  width: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AnimatedSwitcher(
                                      switchInCurve: Curves.easeInOutBack,
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(
                                              scale: animation, child: child),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: !exchange
                                          ? startButton()
                                          : resumeFinishButton(
                                              value: value,
                                              displayTime: displayTime)),
                                ),
                                const VerticalDivider(
                                  endIndent: 15,
                                  indent: 10,
                                  width: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () async {

                                        showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                            ),
                                            elevation: 10,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.6)]
                                                      )
                                                  ),
                                                  height: 500,
                                                  child:
                                                    hours.isEmpty ? FutureBuilder(
                                                      future: context.read<GetWeatherToday>()
                                                        .call(lat: currentLocation!.latitude,
                                                              long: currentLocation!.longitude,),
                                                      builder: (context, snapshot) {
                                                        switch(snapshot.connectionState) {
                                                          case ConnectionState.waiting : return Center(child: CircularProgressIndicator());
                                                          default:
                                                            if (snapshot.hasError) {
                                                              log.d(snapshot.error);
                                                              return Text('nothing');
                                                            } else {
                                                              hours = snapshot.data!;
                                                              return weatherAPIWidget(hours: hours);
                                                            }
                                                        }
                                                      }
                                                    ) : weatherAPIWidget(hours: hours)

                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Weather.cloud_sun_inv,
                                        size: 40,
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
            )
        )
    );
  }

  VietmapGL buildVietmapGL(StopWatchTimer timeClock) {
    return VietmapGL(
      initialCameraPosition:
          const CameraPosition(target: LatLng(90, 100), zoom: 0),
      styleString:
          'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=c3d0f188ff669f89042771a20656579073cffec5a8a69747',
      onMapCreated: (VietmapController controllerMap) {
        controller = controllerMap;
      },
      onUserLocationUpdated: (UserLocation location) async {
        currentLocation = location.position;
        zoom = controller.cameraPosition!.zoom;
        if (!setZoom) {
          zoom = 16;
          setZoom = true;
          await controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: location.position, zoom: zoom)));
        }
        if (timeClock.isRunning) {
          route.add(location.position);
          altitudeSon.add(location.latitude!);
          pathsSon.add(location.position);
          timeIsoSon.add(
              '${DateTime.now().toUtc().toIso8601String().substring(0, 19)}Z');
          int len = pathsSon.length;

          if (len >= 2) {
            var distanceTwoPoint =
                calculateDistance(pathsSon[len - 2], altitudeSon[len-2], pathsSon[len - 1], altitudeSon[len-1]);
            dis += distanceTwoPoint;
          }
          // calculate distance
          for (int i = 0; i < paths.length; i++) {
            await controller
                .addPolyline(PolylineOptions(
              polylineWidth: 3,
              polylineOpacity: 1,
              draggable: true,
              geometry: paths[i],
              polylineColor: Colors.blue,
            ));
          }
          await controller.addPolyline(PolylineOptions(
              geometry: pathsSon,
              polylineColor: Colors.blue,
              polylineWidth: 3,
              polylineOpacity: 1,
              draggable: true));
          setState(() {});
        }
      },
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.COMPASS,
      zoomGesturesEnabled: true,
      compassEnabled: true,
      trackCameraPosition: true,
      myLocationEnabled: true,
      doubleClickZoomEnabled: true,
      dragEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
    );
  }

  Widget startButton() {
    return ElevatedButton(
        onPressed: () async {
          if (!start) {
            timeClock.onStartTimer();
            setState(() {
              start = true;
            });
          } else {
            timeClock.onStopTimer();
            exchange = true;

            // add path to paths
            if (pathsSon.isNotEmpty) {
              paths.add(List.from(pathsSon));
              altitude.add(List.from(altitudeSon));
              timeIso.add(List.from(timeIsoSon));
              // clear data
              pathsSon.clear();
              timeIsoSon.clear();
              altitudeSon.clear();
            }
            setState(() {});
          }
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            fixedSize: const Size(80, 80),
            backgroundColor: Colors.deepOrange,
            shadowColor: Colors.lightBlueAccent),
        child: !start
            ? const Text(
                'START',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              )
            : const Icon(
                Icons.stop,
                size: 40,
              )
    );
  }

  Widget resumeFinishButton({value, displayTime}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
            onTap: () {
              exchange = false;
              timeClock.onStartTimer();

              setState(() {});
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepOrange, width: 1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'RESUME',
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            )
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context, PageTransition(duration: Duration(milliseconds: 500),child: buildSaveActivity(
                context,
                distance: double.parse(dis.toStringAsFixed(2)),
                speed: double.parse(
                    (dis / ((double.parse(value.toString())) / (1000 * 3600)))
                        .toStringAsFixed(2)),
                time: displayTime.substring(0, 8),
              ), type: PageTransitionType.leftToRight));
              // showModalBottomSheet(
              //   context: context,
              //   builder: (context) => buildSaveActivity(
              //     context,
              //     distance: double.parse(dis.toStringAsFixed(2)),
              //     speed: double.parse(
              //         (dis / ((double.parse(value.toString())) / (1000 * 3600)))
              //             .toStringAsFixed(2)),
              //     time: displayTime.substring(0, 8),
              //   ),
              //   isScrollControlled: true,
              //   useSafeArea: true,
              //   backgroundColor: Colors.white,
              // );
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                fixedSize: const Size(80, 80),
                backgroundColor: Colors.deepOrange,
                shadowColor: Colors.lightBlueAccent),
            child: const Text(
              'FINISH',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            )
        ),
      ],
    );
  }

  Widget buildSaveActivity(BuildContext context,
      {distance, speed, time}) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Text(
              'Save Activity',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
              exchange = false;
              timeClock.onStartTimer();
              setState(() {});
            },
            child: const Text('RESUME',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500)),
          ),
          leadingWidth: 100,
        ),
        body: Column(children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(scrollDirection: Axis.vertical, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        style: TextStyle(
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          hintText: 'Your activity name'
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        maxLines: 4,
                        style: TextStyle(
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Tập thể dục hằng ngày là điều thiết yếu để mang lại một cuộc sống hạnh phúc. Cố gắng duy trì đều đặn nhé!'
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Time', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25, color: Colors.deepOrange),),
                              SizedBox(height: 10,),
                              Text('${time}', style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          VerticalDivider(color: Colors.grey, width: 2,),
                          Column(
                            children: [
                              Text('Distance (km)', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25, color: Colors.deepOrange),),
                              SizedBox(height: 10, ),
                              Text('${distance}', style: TextStyle(fontSize: 18))
                            ],
                          ),
                          VerticalDivider(color: Colors.grey, width: 2,),
                          Column(
                            children: [
                              Text('Pace (km/h)', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25, color: Colors.deepOrange), ),
                              SizedBox(height: 10,),
                              Text('${speed}',  style: TextStyle(fontSize: 18))
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Colors.deepOrange,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          colors: [Colors.deepOrange, Colors.blue]
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => FractionallySizedBox(
                                heightFactor: 0.3,
                                widthFactor: 0.8,
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.deepOrange, width: 1),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Do you want to discard this activity?', style: TextStyle(fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              timeClock.onResetTimer();
                                              dis = 0;
                                              start = false;
                                              exchange = false;
                                              setZoom = false;
                                              widget.home.changeStateOpenMap();
                                              paths.clear();
                                              timeIso.clear();
                                              altitude.clear();
                                              await controller.clearLines();
                                            },
                                            child: Text('YES'),),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('NO')
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          );
                        },
                        child: Center(child: Text('Discard Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: const [BoxShadow(color: Colors.black)]),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        try {
                          String? image;
                          await screenshotController.capture().then((value) {
                            image = base64Encode(value!.toList());
                          });

                          Post post = PostModel.map(
                            distance: distance,
                            speed: distance,
                            time: time,
                            paths: List.from(paths),
                            elevation: List.from(altitude),
                            timeISO: List.from(timeIso),
                            image: image,
                          );

                          if (image != null && timeIso.isNotEmpty) {
                            await createGPXFile(paths, altitude, timeIso);
                            await APICall();
                            await widget.home.addPost(post);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error happened with your activity, do it again'))
                            );
                          }

                          // restart state of map

                          timeClock.onResetTimer();
                          dis = 0;
                          start = false;
                          exchange = false;
                          setZoom = false;
                          widget.home.changeStateOpenMap();
                          paths.clear();
                          timeIso.clear();
                          altitude.clear();
                          await controller.clearLines();
                        } catch(e) {
                          log.d(e);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text('Save Activity',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20)),
                        ),
                      ),
                    )
                )
            ),
          )
        ])
    );
  }

  // check permission to access my address
  Future<void> checkPermision() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation().then((value) {
      currentLocation = LatLng(value.latitude!, value.longitude!);
      return value;
    });
  }

  double calculateDistance(LatLng point1, double alt1, LatLng point2, double alt2) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    double lat1Rad = radians(point1.latitude);
    double lon1Rad = radians(point1.longitude);
    double lat2Rad = radians(point2.latitude);
    double lon2Rad = radians(point2.longitude);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double dalt = (alt2 - alt1)/1000;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    double distanceWithElevation = sqrt(pow(distance, 2) + pow(dalt, 2));
    return distanceWithElevation;
  }

  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }
  
  Future<void> getNewAccessToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.get('accessToken');
    refreshToken = sharedPreferences.get('refreshToken');
    expiredAt = sharedPreferences.get('expiredAt');

    if (expiredAt != null &&  DateTime.fromMicrosecondsSinceEpoch(expiredAt as int).isBefore(DateTime.now())) {
      final TokenResponse? result = await appAuth.token(TokenRequest('47ddd41f0b974c40892de24a73dac073', 'stravaflutter://redirect',
          discoveryUrl: 'https://accounts.spotify.com/.well-known/openid-configuration?client_id=47ddd41f0b974c40892de24a73dac073',
          refreshToken: refreshToken,
          scopes: ['user-library-modify', 'user-library-read', 'user-read-email', 'user-read-private', 'playlist-modify-public', 'user-top-read']
      ));

      accessToken = result?.accessToken;
      refreshToken = result?.refreshToken;
      expiredAt = result?.accessTokenExpirationDateTime?.microsecondsSinceEpoch;

      sharedPreferences.setString('accessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      sharedPreferences.setInt('expiredAt', expiredAt);
    }
  }

  Future<void> getAccessTokenRefreshToken() async {
    sharedPreferences = await SharedPreferences.getInstance();

    AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
       AuthorizationTokenRequest(
         '47ddd41f0b974c40892de24a73dac073',
         'stravaflutter://redirect',
         discoveryUrl: 'https://accounts.spotify.com/.well-known/openid-configuration?client_id=47ddd41f0b974c40892de24a73dac073',
         scopes: ['user-library-modify', 'user-library-read', 'user-read-email', 'user-read-private', 'playlist-modify-public', 'user-top-read']
       )
    );

    accessToken = result?.accessToken;
    refreshToken = result?.refreshToken;
    expiredAt = result?.accessTokenExpirationDateTime?.microsecondsSinceEpoch;

    sharedPreferences.setString('accessToken', accessToken);
    sharedPreferences.setString('refreshToken', refreshToken);
    sharedPreferences.setInt('expiredAt', expiredAt);
  }
  Future<void> get50AndTopTracks() async {
    try {
      await getNewAccessToken();
      if (accessToken == null || refreshToken == null) {
        // run get accessToken and set
        await getAccessTokenRefreshToken();
      }
      albumWorkOut =
      await context.read<GetWorkOutAlbum>().call(token: accessToken);
      tracks50 = await context.read<GetTop50Tracks>().call(token: accessToken);
    } catch(e) {
      log.d(e);
    }
  }
}
