import 'package:bookstore/models/khach_hang.dart';
import 'package:bookstore/services/user_session_service.dart';
import 'package:bookstore/services/base_api_service.dart';

enum UserRole {
  customer,
  admin,
  guest,
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String khachHangEndpoint = '/KhachHang';

  // Đăng nhập
  Future<Map<String, dynamic>> login(String taiKhoan, String matKhau) async {
    try {
      print('🔐 Đang đăng nhập với tài khoản: $taiKhoan');
      
      // Lấy danh sách tất cả khách hàng
      final result = await BaseApiService.get(khachHangEndpoint);

      print('📡 API Response: $result');

      if (result['success'] && result['data'] != null) {
        print('✅ Lấy danh sách khách hàng thành công, đang tìm kiếm...');
        
        // Parse danh sách khách hàng
        final data = result['data'];
        final items = data['items']?['\$values'] as List<dynamic>?;
        
        if (items != null) {
          // Tìm khách hàng có tài khoản phù hợp
          KhachHang? foundUser;
          for (var item in items) {
            final khachHang = KhachHang.fromJson(item);
            if (khachHang.taiKhoan == taiKhoan) {
              foundUser = khachHang;
              break;
            }
          }
          
          if (foundUser != null) {
            print('👤 Tìm thấy user: ${foundUser.tenKhachHang} - ${foundUser.soDienThoai}');
            
            // Lưu thông tin user vào session
            UserSessionService().setCurrentUser(foundUser);
            
            print('💾 Đã lưu session, isLoggedIn: ${UserSessionService().isLoggedIn}');
            
            return {
              'success': true,
              'message': 'Đăng nhập thành công',
              'user': foundUser,
            };
          } else {
            print('❌ Không tìm thấy tài khoản: $taiKhoan');
            return {
              'success': false,
              'message': 'Tài khoản không tồn tại',
            };
          }
        } else {
          print('❌ Không có dữ liệu khách hàng');
          return {
            'success': false,
            'message': 'Không có dữ liệu khách hàng',
          };
        }
      } else {
        print('❌ Lấy danh sách khách hàng thất bại: ${result['message']}');
        return {
          'success': false,
          'message': result['message'] ?? 'Lỗi kết nối server',
        };
      }
    } catch (e) {
      print('💥 Lỗi đăng nhập: $e');
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  // Kiểm tra tài khoản đã tồn tại chưa
  Future<Map<String, dynamic>> checkUserExists(String taiKhoan) async {
    try {
      print('🔍 Kiểm tra tài khoản đã tồn tại: $taiKhoan');
      
      // Lấy danh sách tất cả khách hàng
      final result = await BaseApiService.get(khachHangEndpoint);

      if (result['success'] && result['data'] != null) {
        // Parse danh sách khách hàng
        final data = result['data'];
        final items = data['items']?['\$values'] as List<dynamic>?;
        
        if (items != null) {
          // Tìm khách hàng có tài khoản phù hợp
          bool exists = false;
          for (var item in items) {
            final khachHang = KhachHang.fromJson(item);
            if (khachHang.taiKhoan?.toLowerCase() == taiKhoan.toLowerCase()) {
              exists = true;
              break;
            }
          }
          
          print('🔍 Tài khoản $taiKhoan ${exists ? "đã tồn tại" : "chưa tồn tại"}');
          return {
            'exists': exists,
            'message': exists ? 'Tài khoản đã tồn tại' : 'Tài khoản chưa tồn tại',
          };
        }
      }
      
      return {
        'exists': false,
        'message': 'Không thể kiểm tra tài khoản',
      };
    } catch (e) {
      print('💥 Lỗi kiểm tra tài khoản: $e');
      return {
        'exists': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  // Kiểm tra email đã tồn tại chưa
  Future<Map<String, dynamic>> checkEmailExists(String email) async {
    try {
      print('🔍 Kiểm tra email đã tồn tại: $email');
      
      // Lấy danh sách tất cả khách hàng
      final result = await BaseApiService.get(khachHangEndpoint);

      if (result['success'] && result['data'] != null) {
        // Parse danh sách khách hàng
        final data = result['data'];
        final items = data['items']?['\$values'] as List<dynamic>?;
        
        if (items != null) {
          // Tìm khách hàng có email phù hợp
          bool exists = false;
          for (var item in items) {
            final khachHang = KhachHang.fromJson(item);
            if (khachHang.email?.toLowerCase() == email.toLowerCase()) {
              exists = true;
              break;
            }
          }
          
          print('🔍 Email $email ${exists ? "đã tồn tại" : "chưa tồn tại"}');
          return {
            'exists': exists,
            'message': exists ? 'Email đã tồn tại' : 'Email chưa tồn tại',
          };
        }
      }
      
      return {
        'exists': false,
        'message': 'Không thể kiểm tra email',
      };
    } catch (e) {
      print('💥 Lỗi kiểm tra email: $e');
      return {
        'exists': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  // Đăng ký
  Future<Map<String, dynamic>> register(KhachHang khachHang) async {
    try {
      print('📝 Đang đăng ký tài khoản: ${khachHang.taiKhoan}');
      
      final result = await BaseApiService.post(
        khachHangEndpoint,
        khachHang.toRegisterJson(),
      );

      print('📡 Register API Response: $result');

      if (result['success']) {
        print('✅ Đăng ký thành công');
        return {
          'success': true,
          'message': 'Đăng ký thành công',
        };
      } else {
        print('❌ Đăng ký thất bại: ${result['message']}');
        return {
          'success': false,
          'message': result['message'] ?? 'Đăng ký thất bại',
        };
      }
    } catch (e) {
      print('💥 Lỗi đăng ký: $e');
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  // Đăng xuất
  void logout() {
    print('🚪 Đang đăng xuất...');
    UserSessionService().clearSession();
    print('✅ Đã đăng xuất');
  }

  // Kiểm tra người dùng hiện tại có phải là admin không
  bool get isAdmin {
    final currentUser = UserSessionService().currentUser;
    if (currentUser == null) return false;
    
    // Kiểm tra dựa trên tài khoản hoặc email admin
    final isAdminUser = currentUser.taiKhoan == 'admin' || 
           currentUser.email == 'admin@bookstore.com' ||
           currentUser.maKhachHang == 1; // Giả sử ID 1 là admin
    
    print('👑 Kiểm tra admin: $isAdminUser (tài khoản: ${currentUser.taiKhoan}, ID: ${currentUser.maKhachHang})');
    return isAdminUser;
  }

  // Kiểm tra người dùng có đăng nhập không
  bool get isLoggedIn {
    final loggedIn = UserSessionService().isLoggedIn;
    print('🔍 Kiểm tra đăng nhập: $loggedIn');
    return loggedIn;
  }

  // Lấy role của người dùng hiện tại
  UserRole get currentUserRole {
    if (!isLoggedIn) return UserRole.guest;
    if (isAdmin) return UserRole.admin;
    return UserRole.customer;
  }

  // Kiểm tra quyền truy cập trang admin
  bool canAccessAdminPages() {
    return currentUserRole == UserRole.admin;
  }

  // Kiểm tra quyền xem đơn hàng
  bool canViewOrders(int? orderCustomerId) {
    if (currentUserRole == UserRole.admin) return true;
    if (currentUserRole == UserRole.guest) return false;
    
    // Khách hàng chỉ có thể xem đơn hàng của chính họ
    final currentUserId = UserSessionService().currentUserId;
    return currentUserId == orderCustomerId;
  }

  // Kiểm tra quyền tạo đơn hàng
  bool canCreateOrder() {
    return currentUserRole == UserRole.customer;
  }

  // Kiểm tra quyền chỉnh sửa đơn hàng
  bool canEditOrder(int? orderCustomerId) {
    if (currentUserRole == UserRole.admin) return true;
    if (currentUserRole == UserRole.guest) return false;
    
    // Khách hàng chỉ có thể chỉnh sửa đơn hàng của chính họ (nếu chưa xác nhận)
    final currentUserId = UserSessionService().currentUserId;
    return currentUserId == orderCustomerId;
  }

  // Lấy ID người dùng hiện tại
  int? get currentUserId => UserSessionService().currentUserId;

  // Lấy thông tin người dùng hiện tại
  KhachHang? get currentUser => UserSessionService().currentUser;

  // Lấy tên người dùng hiện tại
  String get currentUserName {
    final name = UserSessionService().currentUser?.tenKhachHang ?? '';
    print('👤 Tên người dùng: $name');
    return name;
  }

  // Lấy số điện thoại người dùng hiện tại
  String get currentUserPhone {
    final phone = UserSessionService().currentUser?.soDienThoai ?? '';
    print('📱 Số điện thoại: $phone');
    return phone;
  }
} 