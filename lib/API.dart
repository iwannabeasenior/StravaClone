
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:http_parser/http_parser.dart';

Future<void> APICall() async {
  Random random = Random();
  int external_id = random.nextInt(1000000);
  final db = FirebaseFirestore.instance;
  late Map<String, dynamic> token;
  final String accessToken;
  final String refreshToken;
  bool flag = false;
  await db.collection('token').get().then((snapshot) {
    if (snapshot.docs.isNotEmpty)  {
      for (var doc in snapshot.docs) {
        token = doc.data();
      }
    } else {
      flag = true;
      token = {'init' : 'init'};
    }

  });
  if (flag) {
    final url = Uri.https('strava.com', '/api/v3/oauth/authorize', {
      'response_type': 'code',
      'client_id': '115822',
      'redirect_uri': 'stravaflutter://redirect',
      'approval_prompt': 'force',
      'scope': ['activity:read_all', 'activity:write']
    });

    final result = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: 'stravaflutter');

    final code = Uri
        .parse(result)
        .queryParameters['code'];
    final url1 = Uri.https('www.strava.com', '/api/v3/oauth/token');

    final response = await http.post(url1, body: {
      'client_id': '115822',
      'client_secret': '3c0c197b80c0daff7681457c46724c51562b2c00',
      'grant_type': 'authorization_code',
      'code': code,
    });
    refreshToken = jsonDecode(response.body)['refresh_token'] as String;
    accessToken = jsonDecode(response.body)['access_token'] as String;
    await db.collection('token').add(<String,dynamic> {
      'access_token' : accessToken,
      'refresh_token' : refreshToken,
    });


    final url2 = Uri.https('www.strava.com', '/api/v3/athlete/activities');
    final response2 = await http.get(url2,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        }
    );
    // fetch data activity , but has 1 problem of scope , [list of scope] but only accept the latter scope.
    // final data = jsonDecode(response2.body) as List<dynamic>;
    // data.forEach((element) {
    //   print(element);
    // });

  } else {
    print('update data');
    final refreshTokenOld = token['refresh_token'];
    print('refreshToken : $refreshTokenOld');
    final url = Uri.https('www.strava.com', '/api/v3/oauth/token');
    final response = await http.post(url, body : {
      'client_id' : '115822',
      'client_secret' : '3c0c197b80c0daff7681457c46724c51562b2c00',
      'grant_type' : 'refresh_token',
      'refresh_token' : refreshTokenOld,
    });
    accessToken = jsonDecode(response.body)['access_token'] as String;
    refreshToken = jsonDecode(response.body)['refresh_token'] as String;
    print('refreshTokenOld : $refreshTokenOld');
    print('accessToken : $accessToken');


    print('refreshToken : $refreshToken');
    await db.collection('token').get().then(
        (snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update(
            {
              'refresh_token' :  refreshToken,
              'access_token' : accessToken
            }
            );
          }
        }
    );
  }

  String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
  final uploadUrl = Uri.parse('https://www.strava.com/api/v3/uploads');
  final request = http.MultipartRequest('POST', uploadUrl)
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..files.add(
        await http.MultipartFile.fromPath(
            'file',
            '$downloadsDirectoryPath/gpxFake.gpx',
            contentType: MediaType('application', 'gpx+xml')
        ))
    ..fields.addAll({
      'name' : 'My activity-$external_id',
      'description' : 'Can i run from home to my school ?',
      'trainer' : '0',
      'commute' : '0',
      'data_type' : 'gpx',
      'external_id' : '$external_id',
    });

  final responseUpload = await request.send();
  if (responseUpload.statusCode == 201) {
    print('SUCCESS');
  } else {
    print('FAILED');
  }
}