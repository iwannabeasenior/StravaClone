import '../entity/track.dart';
import '../repositories/track_repository.dart';

class GetDataSpotify {
  final TrackRepository repository;
  GetDataSpotify({required this.repository});
  Future<List<Track>> getMyTopTracks({required token}) async {
    final tracks = await repository.getMyTopTracks(token: token);
    return tracks;
  }
  Future<List<Track>> getTop50Tracks({required token}) async {
    final tracks = await repository.getTop50Tracks(token: token);
    return tracks;
  }
  Future<List<Track>> getWorkOutAlbulm({required token}) async {
    final tracks = await repository.getWorkOutAlbum(token: token);
    return tracks;
  }
}