import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';

class AdminDrawer extends StatelessWidget {
  final String currentPath;

  const AdminDrawer({
    super.key,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'BookStore Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Trang chủ',
            route: AdminRoutes.dashboard,
            isActive: currentPath == AdminRoutes.dashboard,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.book,
            title: 'Sản phẩm',
            route: AdminRoutes.products,
            isActive: currentPath == AdminRoutes.products,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category,
            title: 'Danh mục',
            route: AdminRoutes.categories,
            isActive: currentPath == AdminRoutes.categories,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.class_,
            title: 'Thể loại',
            route: AdminRoutes.genres,
            isActive: currentPath == AdminRoutes.genres,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_cart,
            title: 'Đơn hàng',
            route: AdminRoutes.orders,
            isActive: currentPath == AdminRoutes.orders,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: 'Người dùng',
            route: AdminRoutes.users,
            isActive: currentPath == AdminRoutes.users,
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.account_circle,
            title: 'Tài khoản',
            route: AdminRoutes.profile,
            isActive: currentPath == AdminRoutes.profile,
          ),
          const Spacer(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Đăng xuất',
            onTap: () async {
              // Xử lý đăng xuất
              // await AdminService().logout();
              if (context.mounted) {
                GoRouter.of(context).go(AdminRoutes.login);
              }
            },
            isActive: false,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
    required bool isActive,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Theme.of(context).primaryColor : null,
        ),
      ),
      onTap: onTap ??
          () {
            if (route != null) {
              GoRouter.of(context).go(route);
            }
          },
      tileColor: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
    );
  }
} 