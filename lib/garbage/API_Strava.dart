import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strava_client/strava_client.dart';
import 'package:http_parser/http_parser.dart';


// https thay vì parse vì https có thể thêm body, rất cần cho phương thức get ( đỡ phải viết parse'... dài dòng')
// mỗi url2 là cần thêm /api/v3 : lý do thì vẫn chưa tìm ra, maybe phương thức 'get' là cần , còn post và cái các khác là không
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      const MaterialApp(
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
        title: const Center(child: Text('My page')),
      ),
      body : Center(
        child : ElevatedButton(
          onPressed: () async {
            StravaClient stravaClient = StravaClient(secret: '3c0c197b80c0daff7681457c46724c51562b2c00', clientId: '115822');
            TokenResponse tokenResponse = await stravaClient.authentication.authenticate(scopes: [AuthenticationScope.activity_read_all, AuthenticationScope.activity_write], redirectUrl:"stravaflutter://redirect", callbackUrlScheme:"stravaflutter");
            String accessToken = tokenResponse.accessToken;
            String refreshToken = tokenResponse.refreshToken;
            print(accessToken);
          },
          child : const Icon(Icons.add)
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
          print('result is $result');
          final code = Uri.parse(result).queryParameters['code'];
          final url1 = Uri.https('www.strava.com', '/api/v3/oauth/token');

          final response = await http.post(url1, body : {
            'client_id' : '115822',
            'client_secret' : '3c0c197b80c0daff7681457c46724c51562b2c00',
            'grant_type': 'authorization_code',
            'code' : code,
          });
          final accessToken = jsonDecode(response.body)['access_token'] as String;
          print('token is :$accessToken');
          // ok done , i have accesstoken and refreshtoken, hehe, continue

          final url2 = Uri.https('www.strava.com', '/api/v3/athlete/activities');
          final response2 = await http.get(url2,
            headers: {
            HttpHeaders.authorizationHeader : 'Bearer $accessToken'
            }
          );
          // final data = jsonDecode(response2.body) as List<dynamic>;
          // data.forEach((element) {
          //   print(element);
          // });


          // final response2 = await http.get(Uri.parse('https://www.strava.com/api/v3/athlete/activities?access_token=$accessToken'),
          //               headers: {
          //                             HttpHeaders.authorizationHeader : 'Bearer $accessToken'
          //               });




          // final url3 = Uri.https('www.strava.com', '/api/v3/uploads');
          // final response3 = await http.post(url3,
          // headers: {
          //   HttpHeaders.authorizationHeader : 'Bearer $accessToken'
          // },
          // body : {
          //   'file' : '/storage/emulated/0/Download/gpxgenerator_path.gpx',
          //   'name' : 'My activity',
          //   'description' : 'Can i run from home to my school ?',
          //   'trainer' : 'no',
          //   'commute' : 'no',
          //   'data_type' : 'gpx',
          //   'external_id' : '342341224',
          // });
          // print(response3.toString());
          // print(response3.body);
          // upload activity by ChatGPT

          String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
          if (!(await Permission.storage.status.isGranted)) {
            var status = await Permission.storage.request();
            print('Permission failed');
          }
          final uploadUrl = Uri.parse('https://www.strava.com/api/v3/uploads');
          final request = http.MultipartRequest('POST', uploadUrl)
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..files.add(
            await http.MultipartFile.fromPath(
                'file',
                '$downloadsDirectoryPath/gpxFake.gpx',
                contentType: MediaType('application', 'gpx+xml')
            ));
          // ..fields.addAll({
          //   'name' : 'My activity',
          //   'description' : 'Can i run from home to my school ?',
          //   'trainer' : 'no',
          //   'commute' : 'no',
          //   'data_type' : 'gpx',
          //   'external_id' : '342341224',
          // });

          final responseUpload = await request.send();
          if (responseUpload.statusCode == 201) {
            print('success');
          } else {
            print('fail');
          }
          print('complete');
        },
        child : const Icon(Icons.auto_awesome)
      ),
    );
  }
}

