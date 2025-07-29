import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookstore/models/khach_hang.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5070/api';
  static const String loginEndpoint = '/KhachHang/login';
  static const String registerEndpoint = '/KhachHang/register';
  static const String khachHangEndpoint = '/KhachHang';

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, dynamic>? _parseResponseObject(Map<String, dynamic> jsonData) {
    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    }
    return null;
  }

  List<dynamic> _parseResponseList(Map<String, dynamic> jsonData) {
    if (jsonData['success'] == true && jsonData['data'] != null) {
      final data = jsonData['data'] as Map<String, dynamic>;
      if (data['items'] != null && data['items']['\$values'] != null) {
        return data['items']['\$values'] as List<dynamic>;
      }
    }
    return [];
  }

  Future<KhachHang?> login(String taiKhoan, String matKhau) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: headers,
        body: jsonEncode({
          'taiKhoan': taiKhoan,
          'matKhau': matKhau,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          if (jsonData['data']['user'] != null) {
            return KhachHang.fromJson(jsonData['data']['user']);
          } else if (jsonData['data'] is Map) {
            return KhachHang.fromJson(jsonData['data']);
          }
        }
        
        return KhachHang.fromJson(jsonData);
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<KhachHang?> register({
    required String taiKhoan,
    required String matKhau,
    required String tenKhachHang,
    required String email,
    required String soDienThoai,
    String? diaChi,
    DateTime? ngaySinh,
    String? gioiTinh,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: headers,
        body: jsonEncode({
          'taiKhoan': taiKhoan,
          'matKhau': matKhau,
          'tenKhachHang': tenKhachHang,
          'email': email,
          'soDienThoai': soDienThoai,
          'diaChi': diaChi,
          'ngaySinh': ngaySinh?.toIso8601String(),
          'gioiTinh': gioiTinh,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          if (jsonData['data']['user'] != null) {
            return KhachHang.fromJson(jsonData['data']['user']);
          } else if (jsonData['data'] is Map) {
            return KhachHang.fromJson(jsonData['data']);
          }
        }
        
        return KhachHang.fromJson(jsonData);
      } else {
        print('Register failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<KhachHang?> getCurrentUser(int khachHangId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$khachHangEndpoint/$khachHangId'),
        headers: headers,
      );

      print('Get user response status: ${response.statusCode}');
      print('Get user response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final userData = _parseResponseObject(jsonData);
        return userData != null ? KhachHang.fromJson(userData) : null;
      } else {
        print('Failed to get user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<KhachHang>?> getAllUsers({int page = 1, int pageSize = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$khachHangEndpoint?page=$page&pageSize=$pageSize'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final jsonList = _parseResponseList(jsonData);
        
        return jsonList.map((json) {
          try {
            return KhachHang.fromJson(json);
          } catch (e) {
            print('Error parsing user: $e');
            return null;
          }
        }).where((user) => user != null).cast<KhachHang>().toList();
      } else {
        print('Failed to load users: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading users: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      print('Logout: Simulating successful logout');
      
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
