import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knovator_flutter_test/screens/post_detail_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_state.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final Map<int, int> postRemainingTime = {};
  final Map<int, Timer?> _activeTimers = {};
  final Map<int, bool> _readStatus = {};

  void _initializeTimers(List posts) {
    Random random = Random();
    for (var post in posts) {
      if (!postRemainingTime.containsKey(post.id)) {
        postRemainingTime[post.id] = random.nextInt(50) + 10;
      }
    }
  }

  void _startTimer(int postId) {
    if (_activeTimers[postId] == null && postRemainingTime[postId]! > 0) {
      _activeTimers[postId] =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (postRemainingTime[postId]! > 0) {
            postRemainingTime[postId] = postRemainingTime[postId]! - 1;
          } else {
            timer.cancel();
            _activeTimers[postId] = null;
          }
        });
      });
    }
  }

  void _pauseTimer(int postId) {
    _activeTimers[postId]?.cancel();
    _activeTimers[postId] = null;
  }

  void _markAsRead(int postId) async {
    setState(() {
      _readStatus[postId] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            final posts = state.posts;
            _initializeTimers(posts);

            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final post = posts[index];
                final isRead = _readStatus[post.id] ?? false;

                return VisibilityDetector(
                  key: Key(post.id.toString()),
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction > 0) {
                      _startTimer(post.id);
                    } else {
                      _pauseTimer(post.id);
                    }
                  },
                  child: ListTile(
                    tileColor: isRead ? Colors.white : Colors.yellow[100],
                    title: Text(post.title),
                    trailing: Text(
                      '${postRemainingTime[post.id]}s',
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _pauseTimer(post.id);
                      _markAsRead(post.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(postId: post.id),
                        ),
                      ).then((_) {
                        _startTimer(post.id);
                      });
                    },
                  ),
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No posts available.'));
          }
        },
      ),
    );
  }
}
