

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/library_state.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../font/heart.dart';
import 'package:http/http.dart' as http;

class SpotifyAPI extends StatefulWidget {
  const SpotifyAPI({super.key});

  @override
  State<SpotifyAPI> createState() => _HomeState();
}

class _HomeState extends State<SpotifyAPI> {
  bool _connected = false;
  late ImageUri? currentTrackImageUri;
  String? accessToken;

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
            body: spotifyView(),
          );
        },
    );
  }
  Widget spotifyView() {
    if (_connected) {
      return Container(
        color : Colors.grey,
        child: connected()
      );
    } else {
      SpotifySdk.connectToSpotifyRemote(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
      return isConnecting();
    }
  }
  Widget isConnecting() {
    return Center(
      child: ElevatedButton(
                onPressed: () async {
                  accessToken = await SpotifySdk.getAccessToken(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
                  getAlbum();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  fixedSize: const Size(100, 100),
                ),
                child: const Center(child: Text('Connect', textAlign: TextAlign.center,)),
            ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     ElevatedButton(
      //         onPressed: () async {
      //           accessToken = await SpotifySdk.getAccessToken(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
      //         },
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.green,
      //           shape: const CircleBorder(),
      //           fixedSize: const Size(100, 100),
      //         ),
      //         child: const Center(child: Text('Get access token', textAlign: TextAlign.center,)),
      //     ),
      //     ElevatedButton(
      //         onPressed: () async {
      //             await SpotifySdk.connectToSpotifyRemote(clientId: '47ddd41f0b974c40892de24a73dac073', redirectUrl: 'stravaflutter://redirect');
      //         },
      //         style: ElevatedButton.styleFrom(
      //           shape: const CircleBorder(),
      //           fixedSize: const Size(100, 100),
      //           backgroundColor: Colors.green,
      //         ),
      //         child: const Icon(Icons.settings_remote_rounded, size: 50,),
      //     ),
      //   ],
      // ),
    );
  }

  Widget connected() {
    return StreamBuilder<PlayerState>(
      //declare fisrt track if user are not playing any track
        stream: SpotifySdk.subscribePlayerState(),
        builder: (context, snapshot) {

          var track = snapshot.data?.track;
          currentTrackImageUri = track?.imageUri;
          var playerState = snapshot.data;
          // not waitting , tra ve 1 danh sach bai hat ma tau yeu thich roi tu pick bai dau tien, xep tat ca vao 1 albulm
          if (playerState == null || track == null) {
            // SpotifySdk.play(spotifyUri: "spotify:track:6epn3r7S14KUqlReYr77hA");

            return  Center(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Waiting...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        SpotifySdk.play(spotifyUri: "spotify:track:6epn3r7S14KUqlReYr77hA");
                      },
                      icon: const Icon(Icons.play_arrow))
                ],
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Center(
                      child: Text('By ${track.artist.name}'),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await SpotifySdk.setRepeatMode(repeatMode: RepeatMode.track);
                              await SpotifySdk.toggleRepeat();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.repeat)),

                        ElevatedButton(
                            onPressed: () async {
                              await SpotifySdk.skipPrevious();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.skip_previous)),

                        playerState.isPaused ? ElevatedButton(
                            onPressed: () async {
                              await SpotifySdk.resume();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.play_arrow)) :
                        ElevatedButton(
                            onPressed: () async {
                              await SpotifySdk.pause();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.pause_circle_outline)),

                        ElevatedButton(
                            onPressed: () async {
                              await SpotifySdk.skipNext();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.skip_next)),
                        getLibraryState(track.uri)
                      ],
                    ),
                  ],
                )
              ],
          );
        });
  }
  Widget getLibraryState(String uri) {
    return FutureBuilder(
        future: SpotifySdk.getLibraryState(spotifyUri: uri),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
                onPressed: () async {
                  // state = await SpotifySdk.getLibraryState(spotifyUri: track.uri);
                  if (snapshot.data!.isSaved) {
                    await SpotifySdk.removeFromLibrary(spotifyUri: uri);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Removed from your favourite music',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ))
                        )
                    );
                    setState(() {

                    });
                  } else {
                    await SpotifySdk.addToLibrary(spotifyUri: uri);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Added to your favourite music',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ))
                        )
                    );
                    setState(() {

                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(50, 50),
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                ),
                child:  snapshot.data!.isSaved ? const Icon(Heart.heart_filled) : const Icon(Heart.heart)
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Text('...');
          }
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
  Future<void> getAlbum() async {
    print('accessToken is $accessToken}');
    final uri = Uri.https('api.spotify.com', '/v1/me/top/tracks');
    final responseAlbum = await http.get(
      uri,
      headers: {
        'Authorization' : 'Bearer $accessToken'
      }
    );
    //
    print('status code 1 is : ${responseAlbum.statusCode}');
    // var data = jsonDecode(responseAlbum.body)['items'] as List<Map<String, dynamic>>;
    // var firstTrack = data[0];
    // final uriTrack = Uri.https(
    //     'api.spotify.com',
    //     '/v1/me/player/play',
    //     {
    //       // 'context_uri' : ,
    //       'uris' : ["spotify:track:11dFghVXANMlKmJXsNCbNl"],
    //       'offset' : 0,
    //       'position_ms' : 0,
    //     }
    // );
    // final responsePlayTrack = await http.post(
    //   uriTrack,
    //   headers: {
    //     'Authorization' : 'Bearer $accessToken'
    //   }
    // );
    // print('status code is : ${responsePlayTrack.statusCode}');

  }
}










