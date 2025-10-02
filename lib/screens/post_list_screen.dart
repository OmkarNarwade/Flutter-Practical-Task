import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';
import 'post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List posts = [];
  Map<int, int> timers = {};
  Map<int, Timer?> activeTimers = {};
  final Box postsBox = Hive.box('postsBox');

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final localData = postsBox.get('posts');
    if (localData != null) {
      setState(() => posts = List<Map<String, dynamic>>.from(localData));
    }
    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => posts = data);
        postsBox.put('posts', data);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching posts: $e")));
      }
    }
  }

  void _markAsRead(int postId) {
    final readPosts = postsBox.get('readPosts', defaultValue: <int>[]);
    if (!readPosts.contains(postId)) {
      postsBox.put('readPosts', [...readPosts, postId]);
    }
  }

  bool _isRead(int postId) {
    final readPosts = postsBox.get('readPosts', defaultValue: <int>[]);
    return readPosts.contains(postId);
  }

  void _startTimer(int postId) {
    if (timers[postId] == null) {
      timers[postId] = [10, 20, 25][Random().nextInt(3)];
    }
    if (activeTimers[postId] != null) return;
    activeTimers[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timers[postId]! > 0) {
            timers[postId] = timers[postId]! - 1;
          } else {
            timer.cancel();
            activeTimers[postId] = null;
          }
        });
      }
    });
  }

  void _pauseTimer(int postId) {
    activeTimers[postId]?.cancel();
    activeTimers[postId] = null;
  }

  @override
  void dispose() {
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts List"),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postId = post['id'];
          final isRead = _isRead(postId);

          return VisibilityDetector(
            key: Key("post-$postId"),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.5) {
                _startTimer(postId);
              } else {
                _pauseTimer(postId);
              }
            },
            child: GestureDetector(
              onTap: () {
                _markAsRead(postId);
                _pauseTimer(postId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetailScreen(postId: postId),
                  ),
                ).then((_) => setState(() {}));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isRead ? Colors.white : Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        post['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isRead ? Colors.black54 : Colors.black,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.timer, color: Colors.blue),
                        Text(
                          "${timers[postId] ?? ''}s",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
