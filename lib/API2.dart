import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:strava_client/strava_client.dart';

// https thay vì parse vì https có thể thêm body, rất cần cho phương thức get ( đỡ phải viết parse'... dài dòng')
// mỗi url2 là cần thêm /api/v3 : lý do thì vẫn chưa tìm ra, maybe phương thức 'get' là cần , còn post và cái các khác là không
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        home: MyApp(),
      )
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My page')),
      ),
      body : Center(
        child : ElevatedButton(
          onPressed: () async {
            StravaClient stravaClient = StravaClient(secret: '3c0c197b80c0daff7681457c46724c51562b2c00', clientId: '115822');
            TokenResponse tokenResponse = await stravaClient.authentication.authenticate(scopes: [AuthenticationScope.activity_read_all, AuthenticationScope.activity_write], redirectUrl:"stravaflutter://redirect", callbackUrlScheme:"stravaflutter");
            String accessToken = tokenResponse.accessToken;
            String refreshToken = tokenResponse.refreshToken;
          },
          child : Icon(Icons.add)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final url = Uri.https('strava.com', '/api/v3/oauth/authorize', {
            'response_type' : 'code',
            'client_id' : '115822',
            'redirect_uri' : 'stravaflutter://redirect',
            'approval_prompt' : 'force',
            'scope' : ['activity:read_all', 'activity:write']
          });

          final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: 'stravaflutter');
          final code = Uri.parse(result).queryParameters['code'];
          final url1 = Uri.https('www.strava.com', '/api/v3/oauth/token');

          final response = await http.post(url1, body : {
            'client_id' : '115822',
            'client_secret' : '3c0c197b80c0daff7681457c46724c51562b2c00',
            'grant_type': 'authorization_code',
            'code' : code,
          });
          final accessToken = jsonDecode(response.body)['access_token'] as String;
          print('token is :' + accessToken);
          // ok done , i have accesstoken and refreshtoken, hehe, continue

          final url2 = Uri.https('www.strava.com', '/api/v3/athlete/activities');
          final response2 = await http.get(url2,
            headers: {
            HttpHeaders.authorizationHeader : 'Bearer $accessToken'
            }
          );
          // final response2 = await http.get(Uri.parse('https://www.strava.com/api/v3/athlete/activities?access_token=$accessToken'),
          //               headers: {
          //                             HttpHeaders.authorizationHeader : 'Bearer $accessToken'
          //               });

          // final data = jsonDecode(response2.body) as List<dynamic>;
          // data.forEach((element) {
          //   print(element);
          // });


          final url3 = Uri.https('www.strava.com', '/api/v3/uploads');
          final response3 = await http.post(url3,
          headers: {
            HttpHeaders.authorizationHeader : 'Bearer $accessToken'
          },
          body : {
            'file' : '/C:\\Users\\NguyenTrungThanh\\Downloads\\gpxgenerator_path.gpx/to/gpxgenerator_path.gpx"',
            'name' : 'My activity',
            'description' : 'Can i run from home to my school ?',
            'trainer' : 'no',
            'commute' : 'no',
            'data_type' : 'gpx',
            'external_id' : '342341224',
          });
          print(response3.toString());
          print(response3.body);
          // print('complete');
          // assert(data is List<Map<dynamic, dynamic>>);
        },
        child : Icon(Icons.auto_awesome)
      ),
    );
  }
}

