import '../entity/track.dart';
import '../repositories/track_repository.dart';

class GetTop50Tracks {
  final TrackRepository repository;
  GetTop50Tracks({required this.repository});
  Future<List<Track>> call({required token}) async {
    final tracks = await repository.getTop50Tracks(token: token);
    return tracks;
  }
}
