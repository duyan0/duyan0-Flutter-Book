import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> adminFeatures = [
      {
        'title': 'Quản lý sách',
        'icon': Icons.book,
        'route': '/admin/books',
        'color': Colors.blue,
      },
      {
        'title': 'Quản lý đơn hàng',
        'icon': Icons.shopping_cart,
        'route': '/admin/orders',
        'color': Colors.green,
      },
      {
        'title': 'Quản lý người dùng',
        'icon': Icons.people,
        'route': '/admin/users',
        'color': Colors.orange,
      },
      {
        'title': 'Quản lý danh mục',
        'icon': Icons.category,
        'route': '/admin/categories',
        'color': Colors.purple,
      },
      {
        'title': 'Thống kê doanh thu',
        'icon': Icons.bar_chart,
        'route': '/admin/revenue',
        'color': Colors.red,
      },
      {
        'title': 'Quản lý khuyến mãi',
        'icon': Icons.local_offer,
        'route': '/admin/promotions',
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản trị hệ thống',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC92127),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: adminFeatures.length,
        itemBuilder: (context, index) {
          final feature = adminFeatures[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => context.push(feature['route']),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feature['icon'],
                    size: 48,
                    color: feature['color'],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feature['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 