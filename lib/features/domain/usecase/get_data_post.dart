import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/repositories/post_repository.dart';

class GetDataPost {
  GetDataPost({required repository}) : postRepository = repository;
  final PostRepository postRepository;
  Future<List<Post>> getListPost() async {
    final list = await postRepository.getPosts();
    return list;
  }
}