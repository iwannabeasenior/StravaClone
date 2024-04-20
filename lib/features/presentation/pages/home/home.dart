import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/helper/font/Post.dart' as icon;
import 'package:stravaclone/features/domain/usecase/get_data_post.dart';
import 'package:stravaclone/features/presentation/pages/home/widgets/profile_main.dart';
import 'package:stravaclone/helper/font/task_icon.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../domain/entity/post.dart';
import '../map/vietmap.dart';
import '../../state/home_state.dart';
import '../task/task_page.dart';
import 'widgets/notification.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomeState(
            api: context.read<GetDataPost>()),
        child: const Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            actions: [
              IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/TaskPage');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskFather()));
                },
                icon: const Icon(TaskIcon.tasks),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileMain();
                  }));
                },
                icon: const Icon(
                  Icons.supervised_user_circle,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.redAccent,
                          title: const Text(
                            'Setting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        body: const Center(child: Text('Coming soon')),
                      );
                    }));
                  },
                  icon: const Icon(Icons.settings)),
              // Consumer<HomeChangeNotifier>(builder: (context, home, child) {
              //   return IconButton(
              //       onPressed: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) {
              //           return NotificationHome(
              //               function: caculateTime, posts: home.posts);
              //         }));
              //       },
              //       icon: const Icon(Icons.add_alert_rounded)
              //   );
              // }),
              Selector<HomeState, List<Post>>(
                  builder: (context, value, child) => IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return NotificationHome(
                                  function: caculateTime, posts: value);
                            }));
                      },
                      icon: const Icon(Icons.add_alert_rounded)
                  ),
                  selector: (p0, p1) => p1.posts,
              )
            ],
            title: const Text('Home',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24)),
          ),
          // floatingActionButton: Consumer<HomeChangeNotifier>(
          //   builder: (context, home, child) => FloatingActionButton(
          //       backgroundColor: Colors.white,
          //       onPressed: () async {
          //         context.read<HomeChangeNotifier>().changeStateOpenMap();
          //       },
          //       child: const Icon(
          //         Icons.run_circle,
          //         color: Colors.amber,
          //       )),
          // ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => context.read<HomeState>().changeStateOpenMap(),
            child: const Icon(
              Icons.run_circle,
              color: Colors.amber,
            ),
          ),

          body: Consumer<HomeState>(builder: (context, home, child) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Card(
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('asset/image/profile.png'),
                            ),
                            title: const Text(
                              'Nguyễn Trung Thành',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.directions_run, size: 18),

                                    const SizedBox(width: 10),

                                    Text.rich(TextSpan(
                                        text: caculateTime(index: index),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: const [
                                          TextSpan(
                                              text: ' - Thanh Tri, Ha Noi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500))
                                        ])),
                                  ],
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Your activity, ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Have a good day!',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepOrange),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            // margin: const EdgeInsets.only(right: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const Text('Distance'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${home.posts[index].distance}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                const VerticalDivider(
                                  indent: 10,
                                  endIndent: 30,
                                  width: 0,
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text('Pace'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${home.posts[index].speed} km/h',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                const VerticalDivider(
                                  indent: 10,
                                  endIndent: 30,
                                  width: 0,
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text('Time'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('${home.posts[index].time}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  List<List<LatLng>> list = [];
                                  for (var path in home.posts[index].path!) {
                                    List<LatLng> l = [];
                                    for (var coordinate
                                        in path) {
                                      l.add(LatLng(coordinate.latitude,
                                          coordinate.longitude));
                                    }
                                    list.add(l);
                                  }
                                  late VietmapController controller;
                                  return Hero(
                                    tag: index,
                                    child: VietmapGL(
                                      zoomGesturesEnabled: true,
                                      initialCameraPosition: CameraPosition(
                                          target: list.isEmpty
                                              ? const LatLng(0, 0)
                                              : LatLng(list[0][0].latitude,
                                                  list[0][0].longitude),
                                          zoom: 16),
                                      styleString:
                                          'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=c3d0f188ff669f89042771a20656579073cffec5a8a69747',
                                      onMapCreated: (VietmapController
                                          controllerMap) async {
                                        controller = controllerMap;
                                        setState(() {});
                                      },
                                      onMapRenderedCallback: () async {
                                        // controller work properly only if Map is rendered fullly
                                        for (int i = 0; i < list.length; i++) {
                                          await controller
                                              .addPolyline(PolylineOptions(
                                            polylineWidth: 3,
                                            polylineOpacity: 1,
                                            draggable: true,
                                            geometry: list[i],
                                            polylineColor: Colors.blue,
                                          ));
                                        }

                                        setState(() {});
                                        // dispose after draw polyline
                                        controller.dispose();
                                      },
                                    ),
                                  );
                                }));
                              },
                              child: Hero(
                                tag: index,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(Uint8List.fromList(
                                      base64.decode(home.posts[index].image!))),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(icon.Post.thumbs_up),
                                    color: Colors.deepOrange),
                                const VerticalDivider(
                                  indent: 0,
                                  endIndent: 0,
                                  width: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(context: context,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              alignment: Alignment.center,
                                              heightFactor: 0.5,
                                              widthFactor: 1,
                                              child: Container(
                                                color: Colors.grey,
                                                height: 100,
                                                width: 100,
                                              ),
                                            );
                                          }
                                      );
                                    },
                                    icon: const Icon(icon.Post.comment_alt),
                                    color: Colors.deepOrange),
                                const VerticalDivider(
                                  indent: 0,
                                  endIndent: 0,
                                  width: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(icon.Post.export_alt),
                                    color: Colors.deepOrange),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }, childCount: home.posts.length),
                )
              ],
            );
          }),
        ),
        Selector<HomeState, bool>(
          builder: (context, value, child) {
            return AnimatedPositioned(
                right: 0,
                left: 0,
                bottom: 0,
                // height: home.openMap ? height -15 : -height,
                top: value ? 0 : height,
                duration: const Duration(milliseconds: 300),
                child: const MyMap()
            );
          },
          selector: (p0, p1) => p1.openMap,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // fectchAllPage will be called after ini and build finish
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<HomeState>(context, listen: false).fetchAllPage();
      });
  }

  String caculateTime({index}) {
    var posts = Provider.of<HomeState>(context, listen: false)
        .posts[index]
        .timeISO;
    var lastTimeISO = posts!.last;

    String time = DateTime.parse(lastTimeISO.last).toLocal().toString();
    return time.substring(0, time.length - 7);
  }

}
