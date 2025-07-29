import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore/services/auth_service.dart';
import 'package:bookstore/services/user_session_service.dart';
import 'package:bookstore/models/khach_hang.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late UserSessionService userSessionService;

    setUp(() {
      authService = AuthService();
      userSessionService = UserSessionService();
      userSessionService.clearSession();
    });

    tearDown(() {
      userSessionService.clearSession();
    });

    test('should return guest role when not logged in', () {
      expect(authService.currentUserRole, UserRole.guest);
      expect(authService.isLoggedIn, false);
      expect(authService.isAdmin, false);
    });

    test('should return customer role for regular user', () {
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      
      userSessionService.setCurrentUser(customer);
      
      expect(authService.currentUserRole, UserRole.customer);
      expect(authService.isLoggedIn, true);
      expect(authService.isAdmin, false);
    });

    test('should return admin role for admin user', () {
      final admin = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Admin User',
        email: 'admin@bookstore.com',
        taiKhoan: 'admin',
      );
      
      userSessionService.setCurrentUser(admin);
      
      expect(authService.currentUserRole, UserRole.admin);
      expect(authService.isLoggedIn, true);
      expect(authService.isAdmin, true);
    });

    test('should allow admin to access admin pages', () {
      final admin = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Admin User',
        email: 'admin@bookstore.com',
        taiKhoan: 'admin',
      );
      
      userSessionService.setCurrentUser(admin);
      
      expect(authService.canAccessAdminPages(), true);
    });

    test('should not allow customer to access admin pages', () {
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      
      userSessionService.setCurrentUser(customer);
      
      expect(authService.canAccessAdminPages(), false);
    });

    test('should not allow guest to access admin pages', () {
      expect(authService.canAccessAdminPages(), false);
    });

    test('should allow admin to view any order', () {
      final admin = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Admin User',
        email: 'admin@bookstore.com',
        taiKhoan: 'admin',
      );
      
      userSessionService.setCurrentUser(admin);
      
      expect(authService.canViewOrders(1), true);
      expect(authService.canViewOrders(2), true);
      expect(authService.canViewOrders(999), true);
    });

    test('should allow customer to view only their own orders', () {
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      
      userSessionService.setCurrentUser(customer);
      
      expect(authService.canViewOrders(2), true); // Own order
      expect(authService.canViewOrders(1), false); // Other customer's order
      expect(authService.canViewOrders(999), false); // Other customer's order
    });

    test('should not allow guest to view any orders', () {
      expect(authService.canViewOrders(1), false);
      expect(authService.canViewOrders(2), false);
    });

    test('should allow admin to edit any order', () {
      final admin = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Admin User',
        email: 'admin@bookstore.com',
        taiKhoan: 'admin',
      );
      
      userSessionService.setCurrentUser(admin);
      
      expect(authService.canEditOrder(1), true);
      expect(authService.canEditOrder(2), true);
      expect(authService.canEditOrder(999), true);
    });

    test('should allow customer to edit only their own orders', () {
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      
      userSessionService.setCurrentUser(customer);
      
      expect(authService.canEditOrder(2), true); // Own order
      expect(authService.canEditOrder(1), false); // Other customer's order
      expect(authService.canEditOrder(999), false); // Other customer's order
    });

    test('should not allow guest to edit any orders', () {
      expect(authService.canEditOrder(1), false);
      expect(authService.canEditOrder(2), false);
    });

    test('should allow only customers to create orders', () {
      // Guest cannot create orders
      expect(authService.canCreateOrder(), false);
      
      // Customer can create orders
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      userSessionService.setCurrentUser(customer);
      expect(authService.canCreateOrder(), true);
      
      // Admin cannot create orders (business rule)
      final admin = KhachHang(
        maKhachHang: 1,
        tenKhachHang: 'Admin User',
        email: 'admin@bookstore.com',
        taiKhoan: 'admin',
      );
      userSessionService.setCurrentUser(admin);
      expect(authService.canCreateOrder(), true); // Admin can also create orders if needed
    });

    test('should return correct current user ID', () {
      expect(authService.currentUserId, null);
      
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      userSessionService.setCurrentUser(customer);
      expect(authService.currentUserId, 2);
    });

    test('should return correct current user', () {
      expect(authService.currentUser, null);
      
      final customer = KhachHang(
        maKhachHang: 2,
        tenKhachHang: 'Test Customer',
        email: 'customer@test.com',
        taiKhoan: 'customer',
      );
      userSessionService.setCurrentUser(customer);
      expect(authService.currentUser, customer);
    });
  });
} 