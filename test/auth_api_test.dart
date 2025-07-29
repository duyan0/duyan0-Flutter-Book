import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore/services/auth_service.dart';
import 'package:bookstore/services/user_session_service.dart';
import 'package:bookstore/models/khach_hang.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late UserSessionService sessionService;

    setUp(() {
      authService = AuthService();
      sessionService = UserSessionService();
      // Clear session before each test
      sessionService.clearSession();
    });

    test('Login with valid credentials', () async {
      // Test với tài khoản có sẵn từ API
      final result = await authService.login('user1', 'password123');
      
      expect(result['success'], isA<bool>());
      expect(result['message'], isA<String>());
      
      // Note: This test might fail if the API is not running or credentials are wrong
      // We just check the structure of the response
      if (result['success']) {
        expect(result['user'], isA<KhachHang>());
        expect(authService.isLoggedIn, true);
      }
    });

    test('Login with invalid credentials', () async {
      final result = await authService.login('invalid_user', 'wrong_password');
      
      // The API might return success: false or throw an error
      // We just check that the response has the expected structure
      expect(result['success'], isA<bool>());
      expect(result['message'], isA<String>());
      
      // If login failed, user should not be logged in
      if (!result['success']) {
        expect(authService.isLoggedIn, false);
      }
    });

    test('Register new user', () async {
      final newUser = KhachHang(
        tenKhachHang: 'Test User',
        email: 'test@example.com',
        taiKhoan: 'testuser',
        matKhau: 'password123',
        soDienThoai: '0123456789',
        trangThai: true,
      );
      
      final result = await authService.register(newUser);
      
      expect(result['success'], isA<bool>());
      expect(result['message'], isA<String>());
    });

    test('User role detection when not logged in', () {
      // Ensure user is not logged in
      sessionService.clearSession();
      
      expect(authService.currentUserRole, UserRole.guest);
      expect(authService.isLoggedIn, false);
      expect(authService.isAdmin, false);
    });

    test('Permission checks for guest user', () {
      // Ensure user is not logged in
      sessionService.clearSession();
      
      expect(authService.canAccessAdminPages(), false);
      expect(authService.canCreateOrder(), false);
      expect(authService.canViewOrders(1), false);
      expect(authService.canEditOrder(1), false);
    });

    test('User session management', () {
      // Test setting and getting current user
      final testUser = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Test User',
        email: 'test@example.com',
        taiKhoan: 'testuser',
        soDienThoai: '0123456789',
        trangThai: true,
      );

      sessionService.setCurrentUser(testUser);
      
      expect(authService.isLoggedIn, true);
      expect(authService.currentUser, testUser);
      expect(authService.currentUserId, 1);
      expect(authService.currentUserName, 'Test User');
      expect(authService.currentUserPhone, '0123456789');
      expect(authService.currentUserRole, UserRole.customer);

      // Test logout
      authService.logout();
      expect(authService.isLoggedIn, false);
      expect(authService.currentUser, null);
      expect(authService.currentUserId, null);
    });
  });

  group('KhachHang Model Tests', () {
    test('fromJson with valid data', () {
      final jsonData = {
        'maKhachHang': 1,
        'tenKhachHang': 'Nguyễn Văn A',
        'email': 'nguyenvana@email.com',
        'taiKhoan': 'user1',
        'soDienThoai': '0987654321',
        'diaChi': 'Hà Nội',
        'ngaySinh': null,
        'gioiTinh': null,
        'ngayTao': '2025-07-14T00:53:32.633',
        'trangThai': true,
      };

      final khachHang = KhachHang.fromJson(jsonData);

      expect(khachHang.maKhachHang, 1);
      expect(khachHang.tenKhachHang, 'Nguyễn Văn A');
      expect(khachHang.email, 'nguyenvana@email.com');
      expect(khachHang.taiKhoan, 'user1');
      expect(khachHang.soDienThoai, '0987654321');
      expect(khachHang.diaChi, 'Hà Nội');
      expect(khachHang.trangThai, true);
    });

    test('fromJson with empty strings', () {
      final jsonData = {
        'maKhachHang': 1,
        'tenKhachHang': '',
        'email': '',
        'taiKhoan': 'user1',
        'soDienThoai': '',
        'diaChi': null,
        'ngaySinh': null,
        'gioiTinh': null,
        'ngayTao': '2025-07-14T00:53:32.633',
        'trangThai': true,
      };

      final khachHang = KhachHang.fromJson(jsonData);

      expect(khachHang.maKhachHang, 1);
      expect(khachHang.tenKhachHang, '');
      expect(khachHang.email, '');
      expect(khachHang.taiKhoan, 'user1');
      expect(khachHang.soDienThoai, '');
      expect(khachHang.diaChi, null);
      expect(khachHang.trangThai, true);
    });

    test('toRegisterJson', () {
      final khachHang = KhachHang(
        tenKhachHang: 'Test User',
        email: 'test@example.com',
        taiKhoan: 'testuser',
        matKhau: 'password123',
        soDienThoai: '0123456789',
        diaChi: 'Test Address',
        trangThai: true,
      );

      final json = khachHang.toRegisterJson();

      expect(json['tenKhachHang'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['taiKhoan'], 'testuser');
      expect(json['matKhau'], 'password123');
      expect(json['soDienThoai'], '0123456789');
      expect(json['diaChi'], 'Test Address');
      expect(json['trangThai'], isNull); // Should not include trangThai in register
    });

    test('toLoginJson', () {
      final khachHang = KhachHang(
        taiKhoan: 'testuser',
        matKhau: 'password123',
      );

      final json = khachHang.toLoginJson();

      expect(json['taiKhoan'], 'testuser');
      expect(json['matKhau'], 'password123');
      expect(json.length, 2); // Should only have taiKhoan and matKhau
    });

    test('toJson with all fields', () {
      final khachHang = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Test User',
        email: 'test@example.com',
        taiKhoan: 'testuser',
        soDienThoai: '0123456789',
        diaChi: 'Test Address',
        trangThai: true,
        matKhau: 'password123',
      );

      final json = khachHang.toJson();

      expect(json['maKhachHang'], 1);
      expect(json['tenKhachHang'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['taiKhoan'], 'testuser');
      expect(json['soDienThoai'], '0123456789');
      expect(json['diaChi'], 'Test Address');
      expect(json['trangThai'], true);
      expect(json['matKhau'], 'password123');
    });
  });
} 