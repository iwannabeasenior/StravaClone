import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' ;

Future<Widget> weatherAPI(LatLng? address) async{
  final uri = Uri.https('api.weatherapi.com', '/v1/forecast.json',
      {
        'key' : 'a82d9ff2750d4e339a8100251231911',
        'q' : '${address?.latitude},${address?.longitude}',
        'days' : '1',
      });
  final response = await http.get(uri);
  final data = jsonDecode(response.body);
  DateTime now = DateTime.now();
  int hourNow = now.hour;
  var hourData = data['forecast']['forecastday'][0]['hour'];
  List<Map<String, dynamic>> timeOfDay = [];
  for (var hour in hourData) {
    if (int.parse(hour['time'].substring(11, 13)) >= hourNow) {
      timeOfDay.add(hour);
    }
  }

  return CustomScrollView(
    slivers: <Widget>[
      SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${timeOfDay[index]['time'].substring(11, 16)}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                          Row(
                            children: [
                              Image.network('https:${timeOfDay[index]['condition']['icon']}'),
                              Text(
                                  '${timeOfDay[index]['temp_c']} C',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              const Icon(Icons.water_drop),
                              Text(
                                  '${timeOfDay[index]['chance_of_rain']} %',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  )),
                            ],
                          ),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text('${timeOfDay[index]['condition']['text']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color : Colors.lightBlue
                        ),),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              RichText(
                                  text: TextSpan(
                                    text: 'Precipitation : ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                        text : '${timeOfDay[index]['precip_mm']} %',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange
                                        )
                                      )
                                    ]
                                  ),
                              ),
                              const Divider(),
                              RichText(
                                text: TextSpan(
                                    text: 'Wind :',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                          text : '${timeOfDay[index]['wind_mph']} mph',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange
                                          )
                                      )
                                    ]
                                ),
                              ),
                              const Divider(),
                              RichText(
                                text: TextSpan(
                                    text: 'Humidity :',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                          text : '${timeOfDay[index]['humidity']} %',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange
                                          )
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Cloud : ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                          text : '${timeOfDay[index]['cloud']} %',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange
                                          )
                                      )
                                    ]
                                ),
                              ),
                              const Divider(),
                              RichText(
                                text: TextSpan(
                                    text: 'UV Max : ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                          text : '${timeOfDay[index]['uv']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange
                                          )
                                      )
                                    ]
                                ),
                              ),
                              const Divider(),
                              RichText(
                                text: TextSpan(
                                    text: 'Wind Degree : ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan> [
                                      TextSpan(
                                          text : '${timeOfDay[index]['wind_degree']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange
                                          )
                                      )
                                    ]
                                ),
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
             childCount: timeOfDay.length,
          ),
      )
    ],
  );
}

