import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stravaclone/home/firebase_options.dart';

import 'map.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home : Home(),
  ));
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Stack(
          children: [
              Scaffold(
                bottomNavigationBar: menu(),
                body : TabBarView(
                children: [
                Center(child: Text('Home')),
                MyMap(),
                MyMap2(),
                ],
                )
                ),
              Align(
                child : MyMap2(),
                alignment: Alignment(0,1),
              )
          ],
        )));
  }
  Widget menu() {
    return Container(
      height: 50,
      color : Colors.lightBlueAccent,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Icon(Icons.home),
          Icon(Icons.map),
          Icon(Icons.map_sharp)
        ],
      ),
    );
  }
}
class MyMap2 extends StatefulWidget {
  const MyMap2({super.key});

  @override
  State<MyMap2> createState() => _MyMap2State();
}

class _MyMap2State extends State<MyMap2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  fullscreenDialog: true,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Home1();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end : end);
                    final offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  }
              ));
            } ,
            child: Text('Tap'));
  }
}
class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar : AppBar(
          title: Center(child : Text('Map')),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(1,1)),
        ),
    );
  }
}




















