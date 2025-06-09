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