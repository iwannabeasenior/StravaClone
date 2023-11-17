import 'dart:math';
// import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:stravaclone/garbage/sized_icon_button.dart';

import 'font/heart.dart';
class SpotifyAPI extends StatefulWidget {
  const SpotifyAPI({super.key});

  @override
  State<SpotifyAPI> createState() => _HomeState();
}

class _HomeState extends State<SpotifyAPI> {
  bool _connected = false;
  late ImageUri? currentTrackImageUri;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return First();
  }
  Widget First() {

      return  StreamBuilder(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            backgroundColor: Colors.grey,
            body: bottomAppBar(),
          );
        },
    );
  }
  Widget bottomAppBar() {
    if (_connected) {
      return Container(
        color : Colors.grey,
        child: connected()
      );
    } else {
      return connect();
    }
  }
  Widget connect() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              onPressed: () async {
                await SpotifySdk.getAccessToken(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: CircleBorder(),
                fixedSize: Size(100, 100),
              ),
              child: Center(child: Text('Get access token', textAlign: TextAlign.center,)),
          ),
          ElevatedButton(
              onPressed: () async {
                  await SpotifySdk.connectToSpotifyRemote(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
              } ,
              child: Icon(Icons.settings_remote_rounded, size: 50,),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                fixedSize: Size(100, 100),
                backgroundColor: Colors.green,
              ),
          ),
        ],
      ),
    );
  }
  Widget disConnected() {
    return Container(
      child : Center(
        child : Text('Not connected'),
      ),
      color : Colors.lightBlue,
    );
  }
  Widget connected() {
    return StreamBuilder<PlayerState>(
        stream: SpotifySdk.subscribePlayerState(),
        builder: (context, snapshot) {
          var track = snapshot.data?.track;
          currentTrackImageUri = track?.imageUri;
          var playerState = snapshot.data;
          if (playerState == null || track == null) {
            return Center(
              child: Container(
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getImageFromUri(currentTrackImageUri!),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(track.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedIconButton(
                            width: 50,
                            icon: Icons.repeat,
                            onPressed: () async {
                              await SpotifySdk.toggleRepeat();
                            }),
                        SizedIconButton(
                            width: 50,
                            icon: Icons.skip_previous,
                            onPressed: () async {
                              await SpotifySdk.skipPrevious();
                            }),
                        playerState.isPaused ? SizedIconButton(
                            width: 50,
                            icon: Icons.play_arrow,
                            onPressed: () async {
                              await SpotifySdk.resume();
                            }) :
                        SizedIconButton(
                            width: 50,
                            icon: Icons.pause_circle_outline,
                            onPressed: () async {
                              await SpotifySdk.pause();
                            }),
                        SizedIconButton(
                            width: 50,
                            icon: Icons.skip_next,
                            onPressed: () async {
                              await SpotifySdk.skipNext();
                            }),
                        SizedIconButton(
                            width: 50,
                            icon: Heart.heart,
                            onPressed: () async {
                              var state = await SpotifySdk.getLibraryState(spotifyUri: track.uri);
                              if (state!.isSaved) {
                                await SpotifySdk.removeFromLibrary(spotifyUri: track.uri);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Removed from your favourite music',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ))
                                    )
                                );
                              } else {
                                await SpotifySdk.addToLibrary(spotifyUri: track.uri);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Added to your favourite music',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ))
                                    )
                                );
                              }

                            })
                      ],
                    ),

                  ],
                )


              ],
          );
        });
  }
  Widget getImageFromUri(ImageUri uri) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
            imageUri: uri,
            dimension: ImageDimension.medium,
        ), // build again when Widget restart build
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
                height: 150,
                width: 150,
                child: Image.memory(snapshot.data!));
          } else if (snapshot.hasError) {
            return const Text(
              'Error when get image from URI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            );
          } else {
            return const Text(
                'Getting Image...',
                style : TextStyle(
                  fontSize: 20,
                )
            );
          }
        });
  }
}
//   Random random = Random();
//   String state = random.nextInt(1000000).toString();
//   final url = Uri.https('accounts.spotify.com', 'authorize', {
//     'response_type': 'code',
//     'client_id': '47ddd41f0b974c40892de24a73dac073',
//     'redirect_uri': 'stravaflutter://redirect',
//     'approval_prompt': 'force',
//     'scope': 'user-read-private user-read-email',
//     'state': state,
//   });
//   final result = await FlutterWebAuth2.authenticate(
//       url: url.toString(), callbackUrlScheme: 'stravaflutter');
//
//   final code = Uri.parse(result).queryParameters['code'];
//   print('code is $code');