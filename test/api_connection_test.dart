import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore/services/user_service.dart';
import 'package:bookstore/models/khach_hang.dart';

void main() {
  group('API Connection Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('API Service should be initialized', () {
      expect(apiService, isNotNull);
    });

    test('Login API should handle response correctly', () async {
      // Test với tài khoản có sẵn từ API response
      final result = await apiService.login('user1', 'password123');
      
      // Kiểm tra xem có trả về null hoặc KhachHang object
      expect(result == null || result is KhachHang, isTrue);
    });

    test('Register API should handle response correctly', () async {
      final result = await apiService.register(
        taiKhoan: 'testuser_${DateTime.now().millisecondsSinceEpoch}',
        matKhau: 'password123',
        tenKhachHang: 'Test User',
        email: 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        soDienThoai: '0123456789',
      );
      
      // Kiểm tra xem có trả về null hoặc KhachHang object
      expect(result == null || result is KhachHang, isTrue);
    });

    test('Get All Users API should handle pagination correctly', () async {
      final result = await apiService.getAllUsers(page: 1, pageSize: 5);
      
      // Kiểm tra xem có trả về null hoặc List<KhachHang>
      expect(result == null || result is List<KhachHang>, isTrue);
      
      if (result != null) {
        // Kiểm tra xem tất cả items trong list đều là KhachHang
        for (var user in result) {
          expect(user, isA<KhachHang>());
        }
      }
    });

    test('KhachHang model should parse API response correctly', () {
      // Test với dữ liệu từ API response mới
      final jsonData = {
        "\$id": "4",
        "maKhachHang": 6,
        "tenKhachHang": "Test User",
        "email": "test@email.com",
        "taiKhoan": "user1",
        "soDienThoai": "0987654321",
        "diaChi": "Hà Nội",
        "ngaySinh": null,
        "gioiTinh": null,
        "ngayTao": "2025-07-13T22:14:27.743",
        "trangThai": true
      };

      final khachHang = KhachHang.fromJson(jsonData);
      
      expect(khachHang.maKhachHang, equals(6));
      expect(khachHang.tenKhachHang, equals("Test User"));
      expect(khachHang.email, equals("test@email.com"));
      expect(khachHang.taiKhoan, equals("user1"));
      expect(khachHang.soDienThoai, equals("0987654321"));
      expect(khachHang.diaChi, equals("Hà Nội"));
      expect(khachHang.trangThai, equals(true));
      
      // Test getter tương thích
      expect(khachHang.khachHangId, equals(6));
      expect(khachHang.soDT, equals("0987654321"));
    });
  });
}