import '../entity/track.dart';
import '../repositories/track_repository.dart';

class GetWorkOutAlbum {
  final TrackRepository repository;
  GetWorkOutAlbum({required this.repository});
  Future<List<Track>> call({required token}) async {
    final tracks = await repository.getWorkOutAlbum(token: token);
    return tracks;
  }
}