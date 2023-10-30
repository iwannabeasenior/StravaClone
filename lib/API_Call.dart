import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:strava_client/strava_client.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StravaClient stravaClient = StravaClient(secret: '3c0c197b80c0daff7681457c46724c51562b2c00', clientId: '115822');
  stravaClient.authentication.authenticate(scopes: [AuthenticationScope.activity_read_all, AuthenticationScope.activity_write], redirectUrl:'http://localhost:58817', callbackUrlScheme: 'localhost:58817');
  // stravaClient.uploads.uploadActivity(UploadActivityRequest())
  ActivityStats stat = await stravaClient.athletes.getAthleteStats(126207203);
  print(stat.allRunTotals?.distance);
  
  // final result = await fetchActivity();
  // result.forEach((key, value) {
  //   print(key);
  //   print(value);
  // });
}
// Future<http.Response> createAlbum(String title) {
//   return http.post(
//     Uri.parse('https://strava.com/api/v3/activities'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       "id_str" : "aeiou",
//       "activity_id" : 6,
//       "external_id" : "aeiou",
//       "id" : 0,
//       "error" : "aeiou",
//       "status" : "aeiou"
//     },),
//   );
// }
// get data
Future<Map<String, dynamic>> fetchActivity() async {
  return jsonDecode(await http.get(
      Uri.parse('https://www.strava.com/api/v3/athlete?access_token=e94549e98d4bba52f7d2c049864139484c0b8c81'),
      // headers: {
      //   HttpHeaders.authorizationHeader : 'Bearer e94549e98d4bba52f7d2c049864139484c0b8c81',
      // }
  ).then((value) => value.body));
}