// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:bookstore/features/auth/presentation/pages/home_page.dart';
import 'package:bookstore/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:bookstore/features/auth/presentation/pages/login_page.dart';
import 'package:bookstore/features/auth/presentation/pages/register_page.dart';
import 'package:bookstore/features/splash/presentation/splash_page.dart';
import 'package:bookstore/features/cart/presentation/pages/cart_page.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/features/product/screens/product_detail_screen.dart';
import 'package:bookstore/features/auth/presentation/pages/account_page.dart';
import 'package:bookstore/features/auth/presentation/pages/suggestions_page.dart';
import 'package:bookstore/features/auth/presentation/pages/notifications_page.dart';
import 'package:bookstore/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:bookstore/features/admin/presentation/pages/book_management.dart';
import 'package:bookstore/features/admin/presentation/pages/order_management.dart';
import 'admin_routes.dart';
import 'admin_router.dart';

// HomeShell widget for fixed bottom navigation
class HomeShell extends StatefulWidget {
  final Widget child;
  const HomeShell({required this.child, Key? key}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<String> _paths = [
    '/home',
    '/account',
    '/suggestions',
    '/notifications',
    '/cart',
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
        selectedItemColor: Color(0xFFC92127),
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Color(0xFFC92127)),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: Color(0xFFC92127)),
            label: 'Tài khoản',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star, color: Color(0xFFC92127)),
            label: 'Gợi ý',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications, color: Color(0xFFC92127)),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart, color: Color(0xFFC92127)),
            label: 'Giỏ hàng',
          ),
        ],
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/home/product-detail',
          name: 'product_detail',
          builder: (context, state) {
            final Map<String, dynamic> args =
                state.extra as Map<String, dynamic>;
            final String image = args['image'] as String;
            final String title = args['title'] as String;
            return ProductDetailScreen(image: image, title: title);
          },
        ),
        GoRoute(
          path: '/account',
          name: 'account',
          builder: (context, state) => const AccountPage(),
        ),
        GoRoute(
          path: '/suggestions',
          name: 'suggestions',
          builder: (context, state) => const SuggestionsPage(),
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => const CartPage(),
        ),
      ],
    ),
    // Admin routes
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
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Quản lý người dùng - Đang phát triển'),
            ),
          ),
        ),
        GoRoute(
          path: AdminRoutes.categories,
          name: 'admin_categories',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Quản lý danh mục - Đang phát triển'),
            ),
          ),
        ),
        GoRoute(
          path: AdminRoutes.revenue,
          name: 'admin_revenue',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Thống kê doanh thu - Đang phát triển'),
            ),
          ),
        ),
        GoRoute(
          path: AdminRoutes.promotions,
          name: 'admin_promotions',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Quản lý khuyến mãi - Đang phát triển'),
            ),
          ),
        ),
      ],
    ),
  ],
);
