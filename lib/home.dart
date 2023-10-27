import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home : Home(),
  ));
}
class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> run = [];
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Center(
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
                return MyMap();
              }));
          setState(() {
            run.add(user);
          });
        },
        child : Icon(Icons.run_circle,
        color: Colors.amber,)
      ),
      body : CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index)  {
                  return Container(
                    child: Column(
                      children: [
                        Image(image : AssetImage('asset/image/map.png')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('distance : ${run[index]['distance']}'),
                            Text('speed : ${run[index]['speed']}'),
                            Text('time : ${run[index]['time']}'),
                          ],
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
    );
  }
}
