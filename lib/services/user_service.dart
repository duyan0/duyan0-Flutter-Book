import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:bookstore/models/user.dart';

class ApiService {
  static const String baseUrl =
      'https://localhost:7252/api/User'; // Changed to HTTP

  Map<String, String> headers = {'Content-Type': 'application/json'};

  var logger = Logger();

  Future<List<User>?> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error: $e');
      return null;
    }
  }
}
