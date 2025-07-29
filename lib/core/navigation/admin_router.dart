import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/pages/admin_login_page.dart';
import 'package:bookstore/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:bookstore/features/admin/presentation/pages/product/product_list_page.dart';
import 'package:bookstore/features/admin/presentation/pages/user/user_list_page.dart';
import 'package:bookstore/features/admin/presentation/pages/category/category_list_page.dart';
import 'package:bookstore/features/admin/presentation/pages/genre/genre_list_page.dart';
import 'package:bookstore/features/admin/presentation/pages/admin_profile_page.dart';
import 'package:bookstore/features/admin/presentation/pages/user/user_form_page.dart';
import 'package:bookstore/services/admin_service.dart';

class AdminRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'admin_root');
  
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AdminRoutes.login,
    redirect: _handleRedirect,
    routes: [
      // Admin Login
      GoRoute(
        path: AdminRoutes.login,
        builder: (context, state) => const AdminLoginPage(),
      ),
      
      // Admin Dashboard
      GoRoute(
        path: AdminRoutes.dashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      
      // Admin Products
      GoRoute(
        path: AdminRoutes.products,
        builder: (context, state) => const ProductListPage(),
      ),
      
      // Admin Product Create
      GoRoute(
        path: AdminRoutes.productCreate,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Trang tạo sản phẩm')),
        ),
      ),
      
      // Admin Product Edit
      GoRoute(
        path: AdminRoutes.productEdit,
        builder: (context, state) {
          final productId = (state.extra as Map<String, dynamic>?)?['productId'] as int? ?? 0;
          return Scaffold(
            body: Center(child: Text('Trang sửa sản phẩm ID: $productId')),
          );
        },
      ),
      
      // Admin Users
      GoRoute(
        path: AdminRoutes.users,
        builder: (context, state) => const UserListPage(),
      ),
      GoRoute(
        path: AdminRoutes.userCreate,
        builder: (context, state) => const UserFormPage(),
      ),
      GoRoute(
        path: AdminRoutes.userEdit,
        builder: (context, state) {
          final userId = (state.extra as Map<String, dynamic>?)?['userId'] as int? ?? 0;
          return UserFormPage(userId: userId);
        },
      ),
      // Admin Categories
      GoRoute(
        path: AdminRoutes.categories,
        builder: (context, state) => const CategoryListPage(),
      ),
      GoRoute(
        path: AdminRoutes.categoryCreate,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Trang tạo danh mục')),
        ),
      ),
      GoRoute(
        path: AdminRoutes.categoryEdit,
        builder: (context, state) {
          final categoryId = (state.extra as Map<String, dynamic>?)?['categoryId'] as int? ?? 0;
          return Scaffold(
            body: Center(child: Text('Trang sửa danh mục ID: $categoryId')),
          );
        },
      ),
      
      // Admin Genres
      GoRoute(
        path: AdminRoutes.genres,
        builder: (context, state) => const GenreListPage(),
      ),
      
      // Admin Profile
      GoRoute(
        path: AdminRoutes.profile,
        builder: (context, state) => const AdminProfilePage(),
      ),
      
      // Admin Orders
      GoRoute(
        path: AdminRoutes.orders,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Trang quản lý đơn hàng')),
        ),
      ),
      
      // Admin Order Detail
      GoRoute(
        path: AdminRoutes.orderDetail,
        builder: (context, state) {
          final orderId = (state.extra as Map<String, dynamic>?)?['orderId'] as int? ?? 0;
          return Scaffold(
            body: Center(child: Text('Chi tiết đơn hàng ID: $orderId')),
          );
        },
      ),
    ],
  );
  
  static Future<String?> _handleRedirect(BuildContext context, GoRouterState state) async {
    // Kiểm tra đã đăng nhập chưa
    final isLoggedIn = await AdminService().isAdminLoggedIn();
    
    // Nếu đang ở trang login và đã đăng nhập, chuyển đến dashboard
    if (state.uri.path == AdminRoutes.login && isLoggedIn) {
      return AdminRoutes.dashboard;
    }
    
    // Nếu không ở trang login và chưa đăng nhập, chuyển đến login
    if (state.uri.path != AdminRoutes.login && !isLoggedIn) {
      return AdminRoutes.login;
    }
    
    // Các trường hợp khác không cần redirect
    return null;
  }
} 