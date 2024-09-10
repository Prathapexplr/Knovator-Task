import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> postDetails;

  const PostDetailScreen({super.key, required this.postDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Post Detail',
        style: TextStyle(fontWeight: FontWeight.w700),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          postDetails['body'],
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
