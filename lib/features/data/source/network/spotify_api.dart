import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/track_model.dart';

abstract class SpotifyAPIData {
  Future<List<TrackModel>> getDataTop50({required token});
  Future<List<TrackModel>> getDataMyTop({required token});
  Future<List<TrackModel>> getDataWorkOut({required token});
}

class SpotifyAPIDataImpl implements SpotifyAPIData {
  @override
  Future<List<TrackModel>> getDataTop50({required token}) async {
    List<TrackModel> tracks = [];
    final uri =
        Uri.https('api.spotify.com', '/v1/playlists/37i9dQZEVXbMDoHDwVN2tF');
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['tracks']['items'];
    for (var item in items) {
      var artists = <String>[];
      for (var artist in item['track']['artists']) {
        artists.add(artist['name']);
      }
      tracks.add(TrackModel(
          image: item['track']['album']['images'][0]['url'],
          name: item['track']['name'],
          uri: item['track']['uri'],
          artist: artists));
    }
    return tracks;
  }

  @override
  Future<List<TrackModel>> getDataMyTop({required token}) async {
    List<TrackModel> tracks = [];
    final uri = Uri.https('api.spotify.com', '/v1/me/top/tracks');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    for (var item in data['items']) {
      tracks.add(TrackModel(
        image: item['images'],
        name: item['name'],
        uri: item['uri'],
      ));
    }
    return tracks;
  }
  @override
  Future<List<TrackModel>> getDataWorkOut({required token}) async {
    List<TrackModel> tracks = [];
    final uri = Uri.https('api.spotify.com', '/v1/albums/0hePnTldrfYjUvUhKrR79Y');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['tracks']['items'];
    for (var item in items) {
      var artists = <String>[];
      for (var artist in item['artists']) {
        artists.add(artist['name']);
      }
      tracks.add(TrackModel(
          name: item['name'],
          uri: item['uri'],
          artist: artists));
    }
    return tracks;
  }
}
