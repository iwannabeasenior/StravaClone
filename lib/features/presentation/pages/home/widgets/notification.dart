
import 'package:flutter/material.dart';

class NotificationHome extends StatefulWidget {
  final function;
  final posts;
  const NotificationHome({super.key, required this.function, this.posts});

  @override
  State<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar : AppBar(
            backgroundColor: Colors.deepOrange,
            title: const Text(
              'Notification',
              style : TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body : CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: <Widget> [
              SliverList (
                delegate: SliverChildBuilderDelegate((context, index) =>  Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color : Colors.white,
                        height: 80,
                        child: GestureDetector(child : Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                    image: AssetImage('asset/image/strava_avatar.png'),
                                    fit: BoxFit.cover,
                                  )
                              ),
                              height: 50,
                              width: 80,
                            ),
                            const SizedBox(width: 30,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                const Text(
                                    'You completed a new activity at',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500
                                    )),
                                Text(widget.function(index: index)),
                                // const SizedBox(height: 10,),
                                const Text(
                                    'Go dive into those stats!'
                                ),
                              ],
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
                                              Text('Distance : ${widget.posts[index].distance}',
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 32
                                                  )),
                                              Text('Speed : ${widget.posts[index].speed} km/h',
                                                  style : const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 32
                                                  )),
                                              Text('Time : ${widget.posts[index].time}',
                                                  style : const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 32
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                }
                            )
                            );
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 20,
                      )
                    ],
                  ),
                ),
                    childCount: widget.posts.length),
              ),
            ],
          )
      ),
    );
  }
}
