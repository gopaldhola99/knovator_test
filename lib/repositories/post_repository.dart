import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:knovator_flutter_test/utils/widget_constants.dart';
import '../models/post.dart';
import '../utils/constants.dart';

class PostRepository {
  http.Client httpClient = http.Client();

  Future<List<Post>> fetchPosts() async {
    final response = await httpClient.get(Uri.parse(Constants.baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      errorToast(content: 'Failed to load posts');
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPostDetail(int postId) async {
    final response =
        await httpClient.get(Uri.parse('${Constants.baseUrl}/$postId'));
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      errorToast(content: 'Failed to load post detail');
      throw Exception('Failed to load post detail');
    }
  }
}
