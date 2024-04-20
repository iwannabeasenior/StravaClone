import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stravaclone/features/data/repositories/post_repository_impl.dart';
import 'package:stravaclone/features/data/repositories/task_repository_impl.dart';
import 'package:stravaclone/features/data/repositories/track_repository_impl.dart';
import 'package:stravaclone/features/data/repositories/weather_repository_impl.dart';
import 'package:stravaclone/features/data/source/local/local_storage_posts.dart';
import 'package:stravaclone/features/data/source/local/local_storage_task.dart';
import 'package:stravaclone/features/data/source/network/spotify_api.dart';
import 'package:stravaclone/features/data/source/network/weather_api.dart';
import 'package:stravaclone/features/domain/usecase/get_data_post.dart';
import 'package:stravaclone/features/domain/usecase/get_data_spotify.dart';
import 'package:stravaclone/features/domain/usecase/get_data_weather.dart';
import 'package:stravaclone/features/presentation/state/map_state.dart';
import 'package:stravaclone/helper/routes.dart';

import '/features/presentation/support/firebase_options.dart';
import 'features/domain/usecase/get_data_task.dart';

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

  // post
  GetDataPost getDataPost = GetDataPost(repository: PostRepositoryImpl(localStorage: LocalStorageImpl()));

  //spotify
  GetDataSpotify getDataSpotify = GetDataSpotify(repository: TrackRepositoryImpl(api: SpotifyAPIDataImpl()));

  //weather
  GetDataWeather getDataWeather = GetDataWeather(repository: WeatherRepositoryImpl(api: WeatherAPIImpl()));

  GetDataTask getDataTask = GetDataTask(repo: TaskRepositoryImpl(localStorage: LocalStorageTaskImpl()));

  runApp(MultiProvider(
    providers: [
      Provider.value(
        value: getDataWeather,
      ),
      Provider.value(
        value: getDataSpotify,
      ),
      Provider.value(
        value: getDataPost
      ),

      Provider.value(
        value: getDataTask,
      ),
      ChangeNotifierProvider(
          create: (_) => MapState(),
      )

    ],

    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SafeArea(child: HomePage()),
      routes: Routes.routes(),
      onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
      onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
      initialRoute: 'HomePage',
    ),
  ));
}
