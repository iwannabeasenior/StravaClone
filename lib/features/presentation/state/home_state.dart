import 'package:flutter/material.dart';
import 'package:stravaclone/features/data/source/local/local_storage_posts.dart';
import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:stravaclone/features/domain/usecase/get_data_post.dart';

import '../../data/models/post_model.dart';

class HomeState extends ChangeNotifier {
  final GetDataPost api;
  bool openMap = false;
  List<Post> posts = [];
  HomeState({required this.api});

  List<Post> get getAllPost => posts;

  Future<void> fetchAllPage() async {
    posts = await api.getListPost();
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    posts.add(post);
    LocalStorageImpl().savePostPage(post: post as PostModel);
    notifyListeners();
  }

  void changeStateOpenMap() {
    openMap = !openMap;
    notifyListeners();
  }
}
