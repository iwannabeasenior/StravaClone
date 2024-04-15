import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_options.dart';
import 'package:spotify_sdk/models/player_restrictions.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../../../../../helper/font/heart.dart';
import '../../../../domain/entity/track.dart';
import 'package:spotify_sdk/enums/repeat_mode_enum.dart' as repeat;
import 'package:spotify_sdk/models/player_options.dart' as repeat2;
class SpotifyAPI extends StatefulWidget {
  final List<Track> tracks50;
  final List<Track> albumWorkOut;
  const SpotifyAPI({super.key, required this.tracks50, required this.albumWorkOut});
  @override
  State<SpotifyAPI> createState() => _HomeState();
}

class _HomeState extends State<SpotifyAPI> {
  bool spotifyActivated = false;
  late ImageUri? currentTrackImageUri;
  int choice = 1;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        spotifyActivated = false;
        var data = snapshot.data;
        if (data != null) {
          spotifyActivated = data.connected;
        }
        return spotifyView();
      },
    );
  }

  Widget spotifyView() {
    if (spotifyActivated) {
      return inConnect();
    } else {
      SpotifySdk.connectToSpotifyRemote(
          clientId: '47ddd41f0b974c40892de24a73dac073',
          redirectUrl: 'stravaflutter://redirect'
      );
      return isConnecting();
    }
  }

  Widget isConnecting() {
    return Center(
      // phải đăng nhập và cấp quyền ở spotify app nữa vì spotify sẽ chạy trên điện thoại, khá là đau dâu
      child: ElevatedButton(
        onPressed: () async {
          await SpotifySdk.getAccessToken(
              clientId: '47ddd41f0b974c40892de24a73dac073',
              redirectUrl: 'stravaflutter://redirect',
              scope: 'user-library-modify user-library-read user-read-email user-read-private playlist-modify-public user-top-read'
          );
          await SpotifySdk.connectToSpotifyRemote(
              clientId: '47ddd41f0b974c40892de24a73dac073',
              redirectUrl: 'stravaflutter://redirect'
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: const CircleBorder(),
          fixedSize: const Size(100, 100),
        ),
        child: const Center(
            child: Text(
          'Connect',
          textAlign: TextAlign.center,
        )),
      ),
    );
  }

  Widget inConnect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 30,),
        const Center(
            child: Text('Spotify for Strava', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),)
        ),
        SizedBox(
          height: 250,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.decelerate,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child,);
            },
            reverseDuration: const Duration(milliseconds: 500),
            child: choice == 1 ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrange,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
                  ),
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {
                        setState(() {
                          choice = 2;
                        });
                      }, icon: const Icon(Icons.play_arrow)),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Image.asset('asset/image/top50.jpg'),
                      ),
                      const SizedBox(width: 30,),
                      const Text('Top 50 songs', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrange,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
                  ),
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(onPressed: ()  {
                        setState(() {
                          choice = 3;
                        });
                      }, icon: const Icon(Icons.play_arrow)),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Image.asset('asset/image/workout.jpeg'),
                      ),
                      const SizedBox(width: 30,),
                      const Text('Top work out music', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                    ],
                  ),
                )
              ],
            ) :
            details(),
          ),
        ),

        // controller
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              boxShadow: const [BoxShadow(color: Colors.black)],
            ),
            height:130,
            child: StreamProvider(
              create: (_) => SpotifySdk.subscribePlayerState(),
              // initialData: '1',
              initialData: PlayerState(
                null,
                1,
                2,
                PlayerOptions(
                  repeat2.RepeatMode.track,
                  isShuffling: true,
                ),
                PlayerRestrictions(
                  canRepeatContext: true,
                  canRepeatTrack: true,
                  canSeek: true,
                  canSkipNext: true,
                  canSkipPrevious: true,
                  canToggleShuffle: true
                ),
                isPaused: false,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Selector<PlayerState, Map<String, dynamic>?>(
                          builder: (context, newValue, child) {
                            if(newValue == null) {
                              return Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('asset/image/jb.jpg')
                                )
                            );
                            }
                            return ImageFromUri(uri: ImageUri.fromJson(newValue));
                          },
                          selector: (context , value) => value.track?.imageUri.toJson(), // phải đưa về dạng json vì để imageuri thì khi mình thêm vào thư viện yêu thích thì nó vẫn tính là imageuri thay đổi
                        ),
                        const SizedBox(width: 20,),
                        Consumer<PlayerState>(
                          builder: (context, value, child) {
                            if (value.track == null) {
                              return Center(
                                child: Column(
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
                                          SpotifySdk.play(
                                              spotifyUri: "spotify:track:6epn3r7S14KUqlReYr77hA");
                                        },
                                        icon: const Icon(Icons.play_arrow))
                                  ],
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    value.track?.name ?? 'Unknown',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white), overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Container(child: Text(value.track?.artist.name ?? 'Unknown', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white, overflow: TextOverflow.ellipsis),)),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await SpotifySdk.setRepeatMode(
                                              repeatMode: repeat.RepeatMode.track);
                                          await SpotifySdk.toggleRepeat();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(50, 50),
                                          backgroundColor: Colors.green,
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(Icons.repeat)),
                                    value.isPaused
                                        ? ElevatedButton(
                                        onPressed: () async {
                                          await SpotifySdk.resume();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(50, 50),
                                          backgroundColor: Colors.green,
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(Icons.play_arrow))
                                        : ElevatedButton(
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
                                    addTrackToLibrary(value.track?.uri ?? '1')
                                  ],
                                )

                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
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
            return Center(
              child: Column(
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
                        SpotifySdk.play(
                            spotifyUri: "spotify:track:6epn3r7S14KUqlReYr77hA");
                      },
                      icon: const Icon(Icons.play_arrow))
                ],
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 30,),
              const Center(
                child: Text('Spotify for Strava', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),)
              ),
              SizedBox(
                height: 250,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.decelerate,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child,);
                  },
                  reverseDuration: const Duration(milliseconds: 500),
                  child: choice == 1 ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrange,
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
                        ),
                        height: 100,
                        width: double.infinity,
                        child: Row(
                          children: [
                            IconButton(onPressed: () {
                                setState(() {
                                  choice = 2;
                                });
                            }, icon: const Icon(Icons.play_arrow)),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              child: Image.asset('asset/image/top50.jpg'),
                            ),
                            const SizedBox(width: 30,),
                            const Text('Top 50 songs', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange,
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
                        ),
                        height: 100,
                        width: double.infinity,
                        child: Row(
                          children: [
                            IconButton(onPressed: ()  {
                              setState(() {
                                choice = 3;
                              });
                            }, icon: const Icon(Icons.play_arrow)),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              child: Image.asset('asset/image/workout.jpeg'),
                            ),
                            const SizedBox(width: 30,),
                            const Text('Top work out music', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                          ],
                        ),
                      )
                    ],
                  ) :
                  details(),
                ),
              ),


              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    boxShadow: const [BoxShadow(color: Colors.black)],
                  ),
                  height:130,
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageFromUri(uri: currentTrackImageUri!),
                            const SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  track.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                Text('${track.artist.name}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: const BoxDecoration(

                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            await SpotifySdk.setRepeatMode(
                                                repeatMode: repeat.RepeatMode.track);
                                            await SpotifySdk.toggleRepeat();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(50, 50),
                                            backgroundColor: Colors.green,
                                            shape: const CircleBorder(),
                                          ),
                                          child: const Icon(Icons.repeat)),
                                      playerState.isPaused
                                          ? ElevatedButton(
                                          onPressed: () async {
                                            await SpotifySdk.resume();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(50, 50),
                                            backgroundColor: Colors.green,
                                            shape: const CircleBorder(),
                                          ),
                                          child: const Icon(Icons.play_arrow))
                                          : ElevatedButton(
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
                                      addTrackToLibrary(track.uri)
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget addTrackToLibrary(String uri) {
    return FutureBuilder(
        future: SpotifySdk.getLibraryState(spotifyUri: uri),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.elasticInOut,
              child: ElevatedButton(
                  key: ValueKey(snapshot.data!.isSaved),
                  onPressed: () async {
                    // state = await SpotifySdk.getLibraryState(spotifyUri: track.uri);
                    if (snapshot.data!.isSaved) {
                      await SpotifySdk.removeFromLibrary(spotifyUri: uri);
                      // setState(() {});
                    } else {
                      await SpotifySdk.addToLibrary(spotifyUri: uri);
                      // setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                  ),
                  child: snapshot.data!.isSaved
                      ? const Icon(Heart.heart_filled)
                      : const Icon(Heart.heart)),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const Text('...');
          }
        });
  }

  String concatenate(List<String> list) {
    String result = '';
    for (int i = 0; i < list.length; i++) {
      result += list[i];
      if (i < list.length - 1) {
        result += ', ';
      }
    }
    return result;
  }
  Widget details() {
    return choice == 2 ? Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              choice = 1;
            });
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Center(child: Text('Top 50 songs')),
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrange,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
        ),
        height: 250,
        // padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: widget.tracks50.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  SpotifySdk.play(spotifyUri: widget.tracks50[index].uri!);
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Text('${index+1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(widget.tracks50[index].image!)
                        ),
                      ),

                      const SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.tracks50[index].name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                          const SizedBox(height: 2),
                          // Text('${tracks50[index].artist}'),
                          Text(concatenate(widget.tracks50[index].artist!), style: const TextStyle(fontSize: 13),)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              choice = 1;
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(child: Text('Top work out music')),
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrange,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(1)])
        ),
        height: 230,
        // padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: widget.albumWorkOut.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                SpotifySdk.play(spotifyUri: widget.albumWorkOut[index].uri!);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Text('${index+1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.albumWorkOut[index].name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        const SizedBox(height: 2),
                        // Text('${tracks50[index].artist}'),
                        Text(concatenate(widget.albumWorkOut[index].artist!), style: const TextStyle(fontSize: 13),)
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageFromUri extends StatelessWidget {
  const ImageFromUri({
    super.key,
    required this.uri,
  });

  final ImageUri uri;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: uri,
          dimension: ImageDimension.medium,
        ), // build again when Widget restart build
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 100,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(snapshot.data!)
                )
            );
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
            return const Text('...',
                style: TextStyle(
                  fontSize: 20,
                ));
          }
        });
  }
}
