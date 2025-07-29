import 'package:flutter/material.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  Map<String, dynamic>? _adminInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminInfo();
  }

  Future<void> _loadAdminInfo() async {
    setState(() {
      _isLoading = true;
    });
    final info = await AdminService().getAdminInfo();
    setState(() {
      _adminInfo = info;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Thông tin tài khoản'),
      drawer: AdminDrawer(currentPath: AdminRoutes.profile),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _adminInfo?['hoTen'] ?? 'Admin',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _adminInfo?['vaiTro'] ?? 'Quản trị viên',
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text('Tên đăng nhập: ${_adminInfo?['taiKhoan'] ?? ''}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Email: ${_adminInfo?['email'] ?? ''}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Ngày tạo: ${_adminInfo?['ngayTao'] ?? ''}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Đổi mật khẩu
                        },
                        icon: const Icon(Icons.lock),
                        label: const Text('Đổi mật khẩu'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await AdminService().logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/admin');
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Đăng xuất'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
} 