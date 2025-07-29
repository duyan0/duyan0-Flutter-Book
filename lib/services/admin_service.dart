import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookstore/services/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  static const String adminEndpoint = '/Admin';
  
  // Lưu token admin
  Future<void> _saveAdminToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_token', token);
    await prefs.setBool('is_admin_logged_in', true);
  }
  
  // Lưu thông tin admin
  Future<void> _saveAdminInfo(Map<String, dynamic> adminInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_info', jsonEncode(adminInfo));
  }
  
  // Kiểm tra admin đã đăng nhập chưa
  Future<bool> isAdminLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_admin_logged_in') ?? false;
  }
  
  // Lấy token admin
  Future<String?> getAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token');
  }
  
  // Lấy thông tin admin
  Future<Map<String, dynamic>?> getAdminInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final adminInfoString = prefs.getString('admin_info');
    if (adminInfoString != null) {
      return jsonDecode(adminInfoString) as Map<String, dynamic>;
    }
    return null;
  }
  
  // Đăng xuất admin
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    await prefs.remove('admin_info');
    await prefs.setBool('is_admin_logged_in', false);
  }
  
  // Đăng nhập admin
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔐 Đang đăng nhập admin với tài khoản: $username');
      
      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}$adminEndpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'taiKhoan': username,
          'matKhau': password,
        }),
      );
      
      print('📡 Admin Login Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Giả định API trả về token và thông tin admin
        // Nếu API thực tế khác, cần điều chỉnh code này
        final token = data['token'] ?? 'dummy_token';
        
        // Lưu token và thông tin admin
        await _saveAdminToken(token);
        await _saveAdminInfo(data);
        
        print('✅ Đăng nhập admin thành công: ${data['hoTen']}');
        
        return {
          'success': true,
          'message': 'Đăng nhập thành công',
          'admin': data,
        };
      } else if (response.statusCode == 401) {
        print('❌ Đăng nhập admin thất bại: Sai tên đăng nhập hoặc mật khẩu');
        return {
          'success': false,
          'message': 'Sai tên đăng nhập hoặc mật khẩu',
        };
      } else {
        print('❌ Đăng nhập admin thất bại: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Lỗi đăng nhập: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('💥 Lỗi đăng nhập admin: $e');
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy danh sách sản phẩm (với phân trang)
  Future<Map<String, dynamic>> getProducts({int page = 1, int pageSize = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/SanPham?page=$page&pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy danh sách sản phẩm: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy chi tiết sản phẩm
  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/SanPham/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy chi tiết sản phẩm: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Thêm sản phẩm mới
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/SanPham'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode(productData),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Thêm sản phẩm thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi thêm sản phẩm: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Cập nhật sản phẩm
  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/SanPham/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode(productData),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Cập nhật sản phẩm thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi cập nhật sản phẩm: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Xóa sản phẩm
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${BaseApiService.baseUrl}/SanPham/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Xóa sản phẩm thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi xóa sản phẩm: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy danh sách người dùng
  Future<Map<String, dynamic>> getUsers({int page = 1, int pageSize = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/KhachHang?page=$page&pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy danh sách người dùng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy chi tiết người dùng
  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/KhachHang/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy chi tiết người dùng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Xóa người dùng
  Future<Map<String, dynamic>> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${BaseApiService.baseUrl}/KhachHang/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Xóa người dùng thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi xóa người dùng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Thêm người dùng mới
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/KhachHang'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode(userData),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Thêm người dùng thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi thêm người dùng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Cập nhật thông tin người dùng
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/KhachHang/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode(userData),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Cập nhật thông tin người dùng thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi cập nhật thông tin người dùng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy danh sách đơn hàng
  Future<Map<String, dynamic>> getOrders({int page = 1, int pageSize = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/DonHang?page=$page&pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy danh sách đơn hàng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy chi tiết đơn hàng
  Future<Map<String, dynamic>> getOrderById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/DonHang/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy chi tiết đơn hàng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Cập nhật trạng thái đơn hàng
  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/DonHang/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode({'trangThai': status}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Cập nhật trạng thái đơn hàng thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi cập nhật trạng thái đơn hàng: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Lấy danh sách danh mục
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/DanhMuc'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi lấy danh sách danh mục: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Thêm danh mục mới
  Future<Map<String, dynamic>> createCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/DanhMuc'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode({'name': name}),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Thêm danh mục thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi thêm danh mục: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Cập nhật danh mục
  Future<Map<String, dynamic>> updateCategory(int id, String name) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/DanhMuc/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
        body: jsonEncode({'name': name}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Cập nhật danh mục thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi cập nhật danh mục: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
  
  // Xóa danh mục
  Future<Map<String, dynamic>> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${BaseApiService.baseUrl}/DanhMuc/$id'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await getAdminToken()}',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Xóa danh mục thành công',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi xóa danh mục: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }
} 