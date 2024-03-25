import '../entity/track.dart';

abstract class TrackRepository {
  Future<List<Track>> getTop50Tracks({required token});
  Future<List<Track>> getMyTopTracks({required token});
  Future<List<Track>> getWorkOutAlbum({required token});
}
