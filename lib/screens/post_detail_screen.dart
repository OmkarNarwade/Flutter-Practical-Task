import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String? body;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://jsonplaceholder.typicode.com/posts/${widget.postId}",
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          body = data['body'];
          isLoading = false;
        });
      } else {
        setState(() => errorMessage = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => errorMessage = "Network error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Hero(
          tag: 'post_title_${widget.postId}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              "Post ${widget.postId}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : errorMessage != null
              ? Text(errorMessage!)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              body ?? "No content",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 28,
                                ),
                                SizedBox(width: 18),
                                Icon(
                                  Icons.emoji_emotions,
                                  color: Colors.amber,
                                  size: 28,
                                ),
                                SizedBox(width: 18),
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          "Mark as Read",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 28,
                          ),
                          elevation: 6,
                          shadowColor: Colors.deepPurple.withOpacity(0.4),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
