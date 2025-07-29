import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:bookstore/features/admin/presentation/pages/book_management.dart';
import 'package:bookstore/features/admin/presentation/pages/order_management.dart';
import 'package:bookstore/features/admin/presentation/pages/user_management.dart';
import 'package:bookstore/features/admin/presentation/pages/category_management.dart';
import 'package:bookstore/features/admin/presentation/pages/revenue_statistics.dart';
import 'package:bookstore/features/admin/presentation/pages/promotion_management.dart';
import 'admin_routes.dart';

// AdminShell widget for admin navigation
class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({required this.child, Key? key}) : super(key: key);

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const List<String> _paths = [
    AdminRoutes.dashboard,
    AdminRoutes.books,
    AdminRoutes.orders,
    AdminRoutes.users,
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      context.go(_paths[index]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.path;
    final idx = _paths.indexWhere((p) => location.startsWith(p));
    if (idx != -1 && idx != _selectedIndex) {
      setState(() {
        _selectedIndex = idx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFC92127),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard, color: Color(0xFFC92127)),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book, color: Color(0xFFC92127)),
            label: 'Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart, color: Color(0xFFC92127)),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people, color: Color(0xFFC92127)),
            label: 'Người dùng',
          ),
        ],
      ),
    );
  }
}

final GoRouter adminRouter = GoRouter(
  initialLocation: AdminRoutes.dashboard,
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: AdminRoutes.dashboard,
          name: 'admin_dashboard',
          builder: (context, state) => const AdminDashboard(),
        ),
        GoRoute(
          path: AdminRoutes.books,
          name: 'admin_books',
          builder: (context, state) => const BookManagement(),
        ),
        GoRoute(
          path: AdminRoutes.orders,
          name: 'admin_orders',
          builder: (context, state) => const OrderManagement(),
        ),
        GoRoute(
          path: AdminRoutes.users,
          name: 'admin_users',
          builder: (context, state) => const UserManagement(),
        ),
        GoRoute(
          path: AdminRoutes.categories,
          name: 'admin_categories',
          builder: (context, state) => const CategoryManagement(),
        ),
        GoRoute(
          path: AdminRoutes.revenue,
          name: 'admin_revenue',
          builder: (context, state) => const RevenueStatistics(),
        ),
        GoRoute(
          path: AdminRoutes.promotions,
          name: 'admin_promotions',
          builder: (context, state) => const PromotionManagement(),
        ),
      ],
    ),
  ],
); 
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