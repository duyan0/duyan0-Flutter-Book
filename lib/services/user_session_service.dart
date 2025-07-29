import 'package:bookstore/models/khach_hang.dart';

class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  KhachHang? _currentUser;

  // Set current user after login
  void setCurrentUser(KhachHang user) {
    _currentUser = user;
  }

  // Get current user
  KhachHang? get currentUser => _currentUser;

  // Get current user ID
  int? get currentUserId => _currentUser?.maKhachHang;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Clear user session on logout
  void clearSession() {
    _currentUser = null;
  }

  // Get user's default address (tạm thời trả về địa chỉ mặc định)
  String get userAddress => _currentUser?.diaChi ?? 'Hà Nội';

  // Get user's phone number
  String get userPhone => _currentUser?.soDienThoai ?? '';
}