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

class AdminRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'admin_root');

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
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text('Trang tạo sản phẩm'))),
      ),

      // Admin Product Edit
      GoRoute(
        path: AdminRoutes.productEdit,
        builder: (context, state) {
          final productId =
              (state.extra as Map<String, dynamic>?)?['productId'] as int? ?? 0;
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

      // Admin User Create
      GoRoute(
        path: AdminRoutes.userCreate,
        builder: (context, state) => const UserFormPage(),
      ),

      // Admin User Edit
      GoRoute(
        path: AdminRoutes.userEdit,
        builder: (context, state) {
          final userId =
              (state.extra as Map<String, dynamic>?)?['userId'] as int?;
          return UserFormPage(userId: userId);
        },
      ),

      // Admin Categories
      GoRoute(
        path: AdminRoutes.categories,
        builder: (context, state) => const CategoryListPage(),
      ),

      // Admin Category Create
      GoRoute(
        path: AdminRoutes.categoryCreate,
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text('Trang tạo danh mục'))),
      ),

      // Admin Category Edit
      GoRoute(
        path: AdminRoutes.categoryEdit,
        builder: (context, state) {
          final categoryId =
              (state.extra as Map<String, dynamic>?)?['categoryId'] as int? ??
              0;
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

      // Admin Genre Create
      GoRoute(
        path: AdminRoutes.genreCreate,
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text('Trang tạo thể loại'))),
      ),

      // Admin Genre Edit
      GoRoute(
        path: AdminRoutes.genreEdit,
        builder: (context, state) {
          final genreId =
              (state.extra as Map<String, dynamic>?)?['genreId'] as int? ?? 0;
          return Scaffold(
            body: Center(child: Text('Trang sửa thể loại ID: $genreId')),
          );
        },
      ),

      // Admin Profile
      GoRoute(
        path: AdminRoutes.profile,
        builder: (context, state) => const AdminProfilePage(),
      ),

      // Admin Orders
      GoRoute(
        path: AdminRoutes.orders,
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Trang quản lý đơn hàng')),
            ),
      ),

      // Admin Order Detail
      GoRoute(
        path: AdminRoutes.orderDetail,
        builder: (context, state) {
          final orderId =
              (state.extra as Map<String, dynamic>?)?['orderId'] as int? ?? 0;
          return Scaffold(
            body: Center(child: Text('Chi tiết đơn hàng ID: $orderId')),
          );
        },
      ),
    ],
  );

  // Redirect handler for admin authentication
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    // Check if user is authenticated admin
    // For now, allow all access
    return null;
  }
}
