import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MaterialApp(
    home  : SafeArea(
      child: Home(),
    )
  ));
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('open here'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await APICALL();
        },
      ),
    );
  }
  Future<void> APICALL() async {
    final url = Uri.https('accounts.spotify.com', 'authorize', {
      'response_type': 'code',
      'client_id': '47ddd41f0b974c40892de24a73dac073',
      'redirect_uri': 'stravaflutter://redirect',
      'approval_prompt': 'force',
      'scope': 'user-read-private user-read-email'
    });
    final result = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: 'stravaflutter');

    final code = Uri.parse(result).queryParameters['code'];
    print('code is $code');
  }

}
