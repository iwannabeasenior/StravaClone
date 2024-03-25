import 'package:flutter/material.dart';
import 'package:stravaclone/features/data/source/local/local_storage_posts.dart';
import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/usecase/get_list_posts.dart';

import '../../../data/models/post_model.dart';

class HomeChangeNotifier extends ChangeNotifier {
  final GetListPosts getListPosts;
  final LocalStorageImpl localStorageImpl;
  bool openMap = false;
  List<Post> posts = [];
  HomeChangeNotifier(
      {required this.getListPosts, required this.localStorageImpl});

  List<Post> get getAllPost => posts;

  Future<void> fetchAllPage() async {
    posts = await getListPosts.call();
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    posts.add(post);
    localStorageImpl.savePostPage(post: post as PostModel);
    notifyListeners();
  }

  void changeStateOpenMap() {
    openMap = !openMap;
    notifyListeners();
  }
}
