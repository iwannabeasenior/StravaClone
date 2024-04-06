
import 'dart:convert';
import 'dart:math';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StravaAPI {
  Future<void> pushActivity();
}
class StravaAPIImpl implements StravaAPI {
  @override
  Future<void> pushActivity() async {
      FlutterAppAuth appAuth = const FlutterAppAuth();
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Random random = Random();
      int externalId = random.nextInt(1000000);
      var accessToken = sharedPreferences.get('accessTokenStrava');
      var refreshToken = sharedPreferences.get('refreshTokenStrava');
      var expiredAt = sharedPreferences.get('expiredAtStrava');

      if (accessToken == null) {
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
        expiredAt = jsonDecode(response.body)['expires_at'] as int;

        sharedPreferences.setString('accessTokenStrava', accessToken as String);
        sharedPreferences.setString('refreshTokenStrava', refreshToken as String);
        sharedPreferences.setInt('expiredAtStrava', expiredAt as int);


      } else if (expiredAt as int < DateTime.now().millisecondsSinceEpoch){
        final url = Uri.https('www.strava.com', '/api/v3/oauth/token');
        final response = await http.post(url, body : {
          'client_id' : '115822',
          'client_secret' : '3c0c197b80c0daff7681457c46724c51562b2c00',
          'grant_type' : 'refresh_token',
          'refresh_token' : refreshToken,
        });
        accessToken = jsonDecode(response.body)['access_token'] as String;
        refreshToken = jsonDecode(response.body)['refresh_token'] as String;
        expiredAt = jsonDecode(response.body)['expires_at'] as int;
        sharedPreferences.setString('accessTokenStrava', accessToken as String);
        sharedPreferences.setString('refreshTokenStrava', refreshToken as String);
        sharedPreferences.setInt('expiredAtStrava', expiredAt);
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
          'name' : 'My activity-$externalId',
          'description' : 'Can i run from home to my school ?',
          'trainer' : '0',
          'commute' : '0',
          'data_type' : 'gpx',
          'external_id' : '$externalId',
        });

      final responseUpload = await request.send();
      if (responseUpload.statusCode == 201) {
        print('SUCCESS');
      } else {
        print('FAILED');
      }
    }
}