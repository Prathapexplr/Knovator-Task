// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:knovator/Screens/post_detail_screen.dart';
import 'package:knovator/API/posts_api.dart';
import 'package:knovator/Widgets/timer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostsApi apiService = PostsApi();
  List<dynamic> posts = [];
  Map<int, bool> readStatus = {};
  Map<int, int> timerDurations = {};
  Map<int, Timer?> timers = {};

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    timers.forEach((key, timer) {
      timer?.cancel();
    });
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? postsJson = prefs.getString('posts');

      if (postsJson != null) {
        posts = List<Map<String, dynamic>>.from(json.decode(postsJson));
      } else {
        posts = await apiService.fetchPosts();
        prefs.setString('posts', json.encode(posts));
      }

      setState(() {
        for (var post in posts) {
          readStatus[post['id']] = false;
          timerDurations[post['id']] = _getRandomTimerDuration();
          timers[post['id']] = null;
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text("Error loading posts. Please try again"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      print("Error fetching posts: $e");
    }
  }

  int _getRandomTimerDuration() {
    return [10, 20, 25][(DateTime.now().millisecondsSinceEpoch % 3).toInt()];
  }

  void _startTimer(int postId) {
    if (timers[postId] != null) return;

    timers[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerDurations[postId]! > 0) {
          timerDurations[postId] = timerDurations[postId]! - 1;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer(int postId) {
    timers[postId]?.cancel();
    timers[postId] = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Posts',
        style: TextStyle(fontWeight: FontWeight.w700),
      )),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final isRead = readStatus[post['id']] ?? false;
          final postId = post['id'];
          return VisibilityDetector(
            key: Key(postId.toString()),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 0) {
                _pauseTimer(postId);
              } else {
                _startTimer(postId);
              }
            },
            child: ListTile(
              shape:
                  Border.all(color: const Color.fromARGB(255, 236, 236, 236)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              tileColor: isRead ? Colors.white : Colors.yellow[100],
              title: Text(
                post['title'],
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              trailing: TimerWidget(duration: timerDurations[postId]!),
              onTap: () async {
                try {
                  setState(() {
                    readStatus[post['id']] = true;
                  });
                  final details = await apiService.fetchPostDetails(post['id']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostDetailScreen(postDetails: details),
                    ),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          "Error loading posts details. Please try again"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
