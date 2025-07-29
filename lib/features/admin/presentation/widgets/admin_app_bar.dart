import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primaryColor,
      elevation: 2,
      actions: actions ?? _defaultActions(context),
    );
  }
  
  List<Widget> _defaultActions(BuildContext context) {
    return [
      // Nút thông báo
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {
          _showNotifications(context);
        },
      ),
      
      // Nút profile
      FutureBuilder<Map<String, dynamic>?>(
        future: AdminService().getAdminInfo(),
        builder: (context, snapshot) {
          final adminName = snapshot.data?['hoTen'] ?? 'Admin';
          final firstLetter = adminName.isNotEmpty ? adminName[0].toUpperCase() : 'A';
          
          return PopupMenuButton<String>(
            offset: const Offset(0, 40),
            onSelected: (value) {
              _handleMenuItemSelected(context, value);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Thông tin tài khoản'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Cài đặt'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Đăng xuất'),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
  
  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.orange),
                title: Text('Đơn hàng mới #123'),
                subtitle: Text('Khách hàng: Nguyễn Văn A'),
                trailing: Text('10 phút trước'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.inventory_2, color: Colors.blue),
                title: Text('Sản phẩm sắp hết hàng'),
                subtitle: Text('Sách "Đắc Nhân Tâm" chỉ còn 3 sản phẩm'),
                trailing: Text('1 giờ trước'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.people, color: Colors.green),
                title: Text('Người dùng mới đăng ký'),
                subtitle: Text('Trần Thị B đã đăng ký tài khoản'),
                trailing: Text('2 giờ trước'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Xem tất cả'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleMenuItemSelected(BuildContext context, String value) async {
    switch (value) {
      case 'profile':
        // Xử lý khi chọn profile
        break;
      case 'settings':
        // Xử lý khi chọn settings
        break;
      case 'logout':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        );
        
        if (confirmed == true) {
          await AdminService().logout();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/admin');
          }
        }
        break;
    }
  }
} 