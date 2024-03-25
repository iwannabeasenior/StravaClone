import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/repositories/post_repository.dart';

class GetListPosts {
  GetListPosts({required repository}) : postRepository = repository;
  final PostRepository postRepository;
  Future<List<Post>> call() async {
    final list = await postRepository.getPosts();
    return list;
  }
}