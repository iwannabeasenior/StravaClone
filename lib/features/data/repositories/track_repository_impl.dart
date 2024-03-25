import 'package:stravaclone/features/domain/entity/track.dart';
import 'package:stravaclone/features/domain/repositories/track_repository.dart';

import '../source/network/spotify_api.dart';

class TrackRepositoryImpl implements TrackRepository {
  SpotifyAPIData api;
  TrackRepositoryImpl({required this.api});
  @override
  Future<List<Track>> getTop50Tracks({required token}) async {
    final data = api.getDataTop50(token: token);
    return data;
  }

  @override
  Future<List<Track>> getMyTopTracks({required token}) {
    final data = api.getDataMyTop(token: token);
    return data;
  }

  @override
  Future<List<Track>> getWorkOutAlbum({required token}) {
    final data = api.getDataWorkOut(token: token);
    return data;
  }
}
