
import 'package:flutter/material.dart';
import 'package:stravaclone/features/presentation/pages/home/widgets/chart.dart';
class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  int count = 0;
  List<Map<String, dynamic>> run = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('asset/image/profile.png'),
                const Text(
                  'Nguyễn Trung Thành',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color : Colors.deepOrange
                  ),
                )
              ],
            )
          ), 
          const Divider(color : Colors.grey),
          const Expanded(
            flex: 1,
            child : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(alignment: Alignment.topLeft,
                    child: Text(
                      'This week',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('Distance'),
                          Text(
                              '100m',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                              ),
                          )
                        ],
                      ),
                      VerticalDivider(color : Colors.black),
                      Column(
                        children: [
                          Text('Time'),
                          Text(
                            '1h20p',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      VerticalDivider(color : Colors.black),
                      Column(
                        children: [
                          Text('Elevation'),
                          Text(
                              '23ft',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                              ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ),
          const Divider(color: Colors.grey),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(flex : 1, child : Text(
                      'Number of jogging times per week : $count',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                  ) ),
                  Expanded(flex : 4, child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Chart())),
                ],
              ),
          ),
        ],
      )
    );
  }
}
