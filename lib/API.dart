
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';

Future<void> APICall() async {
  Random random = Random();
  int external_id = random.nextInt(1000000);
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
  final accessToken = jsonDecode(response.body)['access_token'] as String;

  final url2 = Uri.https('www.strava.com', '/api/v3/athlete/activities');
  final response2 = await http.get(url2,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken'
      }
  );

  String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
  if (!(await Permission.storage.status.isGranted)) {
    await Permission.storage.request();
  }

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
  'name' : 'My activity',
  'description' : 'Can i run from home to my school ?',
  'trainer' : 'no',
  'commute' : 'no',
  'data_type' : 'gpx',
  'external_id' : '$external_id',
  });

  final responseUpload = await request.send();
  if (responseUpload.statusCode == 201) {
  print('success');
  } else {
  print('fail');
  }

}