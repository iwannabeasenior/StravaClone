import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stravaclone/map/strava_api.dart';
import 'package:stravaclone/home/profile/profile_main.dart';
import '../map/generate_gpx_file.dart';
import '../map/map.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // create new file named "gpxFake.gpx" to save activity
  if (Platform.isAndroid && ! await File('/storage/emulated/0/Download/gpxFake.gpx').exists()) {
    await Directory('/storage/emulated/0/Download').create(recursive: true);
    File file = File('/storage/emulated/0/Download/gpxFake.gpx');
    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }
    await file.writeAsString('Here your new file will save your activity');
  } else {
  }
  if (!(await Permission.storage.status.isGranted)) {
    await Permission.storage.request();
  }
  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home : SafeArea(child: Home()),
  ));
}
class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> run = [];
  late Map<String, dynamic> token;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfileMain();
                    }));
            },
            icon: const Icon(Icons.supervised_user_circle,),
          ),
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar : AppBar(
                      backgroundColor: Colors.black12,
                      title: const Text(
                        'Setting',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color : Colors.greenAccent,
                        ),
                      ),
                    ),
                    body: const Center(child: Text('Coming soon')),

                  );
                }));
          }, icon: const Icon(Icons.settings)),
          IconButton(onPressed: () {

          }, icon: const Icon(Icons.find_in_page)),
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SafeArea(
                    child: Scaffold(
                      appBar : AppBar(
                        backgroundColor: Colors.blueGrey,
                        title: const Text(
                          'Notification',
                          style : TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                      body : CustomScrollView(
                          slivers: <Widget> [
                            SliverList (
                              delegate: SliverChildBuilderDelegate((context, index) =>  Card(child : Container(
                                color : index % 2 == 1 ? Colors.amberAccent : Colors.greenAccent,
                                height: 80,
                                child: GestureDetector(child : Column(
                                  children: [
                                    const Icon(Icons.snowshoeing),
                                    const SizedBox(height: 10,),
                                    Text(
                                      'You completed a new activity at ${run[index]['timeISO'][run[index]['timeISO'].length-1] as String}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    )),
                                    const SizedBox(height: 10,),
                                    const Text(
                                      'Go dive into those stats!'
                                    ),
                                  ],
                                ),
                                  onTap : () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return SafeArea(
                                              child: Scaffold(
                                                body : Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text('Distance : ${run[index]['distance']}',
                                                          style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 32
                                                          )),
                                                      Text('Speed : ${run[index]['speed']} km/h',
                                                          style : const TextStyle(
                                                              color: Colors.red,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 32
                                                          )),
                                                      Text('Time : ${run[index]['time']}',
                                                          style : const TextStyle(
                                                              color: Colors.red,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 32
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          );
                                        }));
                                  },
                                ),
                              ),),
                                  childCount: run.length),
                            ),
                          ],
                        )),
                  );
                }));

          }, icon: const Icon(Icons.add_alert_rounded)),
        ],
        title: const Center(
          child: Text('Your routes',style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 32
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final user = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const SafeArea(child: MyMap());
              }
          ));
          if (user['timeISO'].length > 0 && user['distance'] != 'unvalid') {
            List<LatLng> list = [];
            for (var coordinate in user['path']) {
              list.add(LatLng(coordinate.latitude, coordinate.longitude));
            }
            await createGPXFile(list, user['timeISO']);
            await APICall();
            run.add(user);
            setState(()  {
            });
          } else if (user['timeISO'].length == 0){
            showDialog(context: context,
                builder: (context) {
                  return const AlertDialog(
                    backgroundColor: Colors.lightBlue,
                    title: Text('Your activity is unvalid',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )),
                  );
                });
          }
        },
        child : const Icon(Icons.run_circle,
        color: Colors.amber,)
      ),
      body : CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index)  {
                  return Card(
                    shape: const CircleBorder(),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.supervised_user_circle_rounded, size: 50, color: Colors.red),
                          title: const Text(
                            'Nguyễn Trung Thành',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          subtitle: Row(
                            children: [
                              const Icon(Icons.snowshoeing),
                              Text(
                                  run[index]['timeISO'][run[index]['timeISO'].length-1] + ' at Thanh Tri, HN'
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap : () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  List<LatLng> list = [];
                                  print(run[index]['timeISO'][run[index]['timeISO'].length-1]);
                                  for (var coordinate in run[index]['path']) {
                                    list.add(LatLng(coordinate.latitude, coordinate.longitude));
                                  }

                                  return GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: list.isEmpty ? const LatLng(0,0) : LatLng(list[0].latitude, list[0].longitude),
                                          zoom: 18
                                      ),
                                      polylines: {
                                        Polyline(
                                          polylineId: const PolylineId('A'),
                                          points: list,
                                          color : Colors.red,
                                        )
                                      }
                                  );
                                }));
                          },
                          child: const Image(image : AssetImage('asset/image/map.png'),
                          ),
                        ),
                        Container(
                          color: Colors.pink,
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Distance : ${run[index]['distance']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                              Text('Speed : ${run[index]['speed']} km/h',
                              style : const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              )),
                              Text('Time : ${run[index]['time']}',
                              style : const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              childCount: run.length
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    db.collection('information').get().then((event) {
      for (var doc in event.docs) {
        run.add(doc.data());
      }
    }
    ).then((value) {
      setState(() {});
    });
  }
}




