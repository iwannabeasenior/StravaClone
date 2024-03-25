import '../entity/track.dart';
import '../repositories/track_repository.dart';

class GetMyTopTracks {
  final TrackRepository repository;
  GetMyTopTracks({required this.repository});
  Future<List<Track>> call({required token}) async {
    final tracks = await repository.getMyTopTracks(token: token);
    return tracks;
  }
}