// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  }
  

  // stravaClient.uploads.uploadActivity(UploadActivityRequest())
  // ActivityStats stat = await stravaClient.athletes.getAthleteStats(126207203);
  // print(stat.allRunTotals?.distance);
  // final _url = Uri.parse('http://www.strava.com/oauth/authorize?client_id=115822&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=activity:read_all');
  // await launchUrl(_url);
  // take code



  //
  // final result = await fetchActivity();
  // result.forEach((key, value) {
  //   print(key);
  //   print(value);
  // });

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
// Future<Map<String, dynamic>> fetchActivity() async {
//   return jsonDecode(await http.get(
//       Uri.parse('https://www.strava.com/api/v3/athlete?access_token=e94549e98d4bba52f7d2c049864139484c0b8c81'),
//       // headers: {
//       //   HttpHeaders.authorizationHeader : 'Bearer e94549e98d4bba52f7d2c049864139484c0b8c81',
//       // }
//
//   ).then((value) => value.body));
// }