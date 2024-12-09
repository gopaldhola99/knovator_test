import 'dart:convert';
import 'package:knovator_flutter_test/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class LocalStorage {
  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString(Constants.postsKey, json.encode(postsJson));
  }

  Future<List<Post>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString(Constants.postsKey);
    if (postsJson != null) {
      final List<dynamic> data = json.decode(postsJson);
      return data.map((json) => Post.fromJson(json)).toList();
    }
    return [];
  }
}
