import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BaseApiService {
  static String get baseUrl {
    // Sử dụng localhost khi chạy trên web, 10.0.2.2 khi chạy trên mobile (Android emulator)
    if (kIsWeb) {
      return 'http://localhost:5070/api';
    } else {
      return 'http://10.0.2.2:5070/api';
    }
  }
  
  // Helper method để xử lý response chung
  static Map<String, dynamic> handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': data['success'] ?? true,
          'message': data['message'] ?? 'Thành công',
          'data': data['data'],
          'pagination': data['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Lỗi server',
          'data': null,
          'pagination': null,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi xử lý dữ liệu: $e',
        'data': null,
        'pagination': null,
      };
    }
  }

  // Helper method để xử lý lỗi
  static Map<String, dynamic> handleError(dynamic error) {
    return {
      'success': false,
      'message': 'Lỗi kết nối: $error',
      'data': null,
      'pagination': null,
    };
  }

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );
      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: json.encode(body),
      );
      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: json.encode(body),
      );
      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );
      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }
  
  // Instance methods for HTTP requests
  Future<http.Response> httpGet(String endpoint, {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
  }

  Future<http.Response> httpPost(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: json.encode(body),
    );
  }

  Future<http.Response> httpPut(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: json.encode(body),
    );
  }

  Future<http.Response> httpDelete(String endpoint, {Map<String, String>? headers}) async {
    return await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
  }
}
