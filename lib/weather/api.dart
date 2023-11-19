import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


   Future<Map<String, dynamic>> api(LatLng? address) async{
    final uri = Uri.https('api.weatherapi.com', '/v1/forecast.json',
    {
      'key' : 'a82d9ff2750d4e339a8100251231911',
      'q' : '${address?.latitude},${address?.longitude}',
      'days' : '2',
    });
    final response = await http.get(uri);
    // print(response.body);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    DateTime now = DateTime.now();
    int hour = now.hour;
    return data['current'];

    // data['forcast']['forecastday'][0]['hour']
    // data['forcast']['forecastday'][1]['hour']
  }

