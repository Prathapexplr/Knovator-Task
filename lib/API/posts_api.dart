import 'dart:convert';
import 'package:http/http.dart' as http;

class PostsApi {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPostDetails(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load post details');
      }
    } catch (e) {
      throw Exception('Error fetching post details: $e');
    }
  }
}
