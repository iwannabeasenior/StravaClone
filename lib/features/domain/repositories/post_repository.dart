import 'package:stravaclone/features/domain/entity/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
}