import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/data/repositories/post_repository_impl.dart';
import 'package:stravaclone/features/data/repositories/track_repository_impl.dart';
import 'package:stravaclone/features/data/repositories/weather_repository_impl.dart';
import 'package:stravaclone/features/data/source/local/local_storage_posts.dart';
import 'package:stravaclone/features/data/source/network/spotify_api.dart';
import 'package:stravaclone/features/data/source/network/weather_api.dart';
import 'package:stravaclone/features/domain/usecase/get_list_posts.dart';
import 'package:stravaclone/features/domain/usecase/get_top_50_tracks.dart';
import 'package:stravaclone/features/domain/usecase/get_weather_today.dart';
import 'package:stravaclone/features/domain/usecase/get_work_out_album.dart';
import 'package:stravaclone/features/presentation/pages/home/home.dart';

import '/features/presentation/support/firebase_options.dart';

// create new file named "gpxFake.gpx" to save activity
void createSaveFile() async {
  if (Platform.isAndroid &&
      !await File('/storage/emulated/0/Download/gpxFake.gpx').exists()) {
    await Directory('/storage/emulated/0/Download').create(recursive: true);
    File file = File('/storage/emulated/0/Download/gpxFake.gpx');
    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }
    await file.writeAsString('Here your new file will save your activity');
  } else {}
  if (!(await Permission.storage.status.isGranted)) {
    await Permission.storage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  createSaveFile();

  LocalStorageImpl localStorageImpl = LocalStorageImpl();
  PostRepositoryImpl postRepositoryImpl =
      PostRepositoryImpl(localStorage: localStorageImpl);
  GetListPosts getListPosts = GetListPosts(repository: postRepositoryImpl);

  SpotifyAPIDataImpl spotifyAPIDataImpl = SpotifyAPIDataImpl();
  TrackRepositoryImpl trackRepositoryImpl =
      TrackRepositoryImpl(api: spotifyAPIDataImpl);
  GetTop50Tracks getTop50Tracks =
      GetTop50Tracks(repository: trackRepositoryImpl);
  GetWorkOutAlbum getWorkOutAlbum = GetWorkOutAlbum(repository: trackRepositoryImpl);

  WeatherAPIImpl weatherAPIImpl = WeatherAPIImpl();
  WeatherRepositoryImpl weatherRepositoryImpl =
      WeatherRepositoryImpl(api: weatherAPIImpl);
  GetWeatherToday getWeatherToday = GetWeatherToday(repository: weatherRepositoryImpl);

  runApp(MultiProvider(
    providers: [
      Provider.value(
        value: getListPosts,
      ),
      Provider.value(
        value: localStorageImpl,
      ),
      Provider.value(
        value: getTop50Tracks,
      ),
      Provider.value(
        value: getWorkOutAlbum
      ),
      Provider.value(
        value: getWeatherToday
      )
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: HomePage()),
    ),
  ));
}
