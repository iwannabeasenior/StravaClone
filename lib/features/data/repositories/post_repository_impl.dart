import 'package:stravaclone/features/data/source/local/local_storage_posts.dart';
import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final LocalStorage localStorage;
  PostRepositoryImpl({required this.localStorage});
  @override
  Future<List<Post>> getPosts() async {
    var allPosts =  await localStorage.loadPostPage();
    return allPosts;
  }
}