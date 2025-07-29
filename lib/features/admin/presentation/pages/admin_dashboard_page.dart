import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:bookstore/services/product_service.dart';
import 'package:bookstore/services/order_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookstore/features/admin/presentation/widgets/dashboard_card.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isLoading = true;
  int _totalProducts = 0;
  int _totalUsers = 0;
  int _totalOrders = 0;
  int _pendingOrders = 0;
  Map<String, dynamic>? _adminInfo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy thông tin admin
      _adminInfo = await AdminService().getAdminInfo();
      
      // Lấy tổng số sản phẩm
      final productsResult = await AdminService().getProducts();
      if (productsResult['success'] && productsResult['data'] != null) {
        final productsData = productsResult['data'];
        if (productsData['data'] != null && productsData['data']['\$values'] != null) {
          _totalProducts = (productsData['data']['\$values'] as List).length;
        }
      }
      
      // Lấy tổng số người dùng
      final usersResult = await AdminService().getUsers();
      if (usersResult['success'] && usersResult['data'] != null) {
        final usersData = usersResult['data'];
        if (usersData['data'] != null && usersData['data']['\$values'] != null) {
          _totalUsers = (usersData['data']['\$values'] as List).length;
        }
      }
      
      // Lấy tổng số đơn hàng
      final ordersResult = await AdminService().getOrders();
      if (ordersResult['success'] && ordersResult['data'] != null) {
        final ordersData = ordersResult['data'];
        if (ordersData['data'] != null && ordersData['data']['\$values'] != null) {
          final orders = ordersData['data']['\$values'] as List;
          _totalOrders = orders.length;
          
          // Đếm số đơn hàng chưa xử lý
          _pendingOrders = orders.where((order) {
            return order['trangThai'] == 'Chờ xác nhận';
          }).length;
        }
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Tổng quan'),
      drawer: AdminDrawer(currentPath: AdminRoutes.dashboard),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chào mừng admin
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào mừng, ${_adminInfo?['hoTen'] ?? 'Admin'}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _adminInfo?['vaiTro'] ?? 'Quản trị viên',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Thống kê
                  const Text(
                    'Thống kê',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Cards thống kê
                  GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 768 ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DashboardCard(
                        title: 'Tổng sản phẩm',
                        value: _totalProducts.toString(),
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                        onTap: () => context.go(AdminRoutes.products),
                      ),
                      DashboardCard(
                        title: 'Tổng người dùng',
                        value: _totalUsers.toString(),
                        icon: Icons.people,
                        color: Colors.green,
                        onTap: () => context.go(AdminRoutes.users),
                      ),
                      DashboardCard(
                        title: 'Tổng đơn hàng',
                        value: _totalOrders.toString(),
                        icon: Icons.shopping_bag,
                        color: Colors.orange,
                        onTap: () => context.go(AdminRoutes.orders),
                      ),
                      DashboardCard(
                        title: 'Đơn chờ xử lý',
                        value: _pendingOrders.toString(),
                        icon: Icons.pending_actions,
                        color: Colors.red,
                        onTap: () => context.go(AdminRoutes.orders),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Các chức năng chính
                  const Text(
                    'Chức năng chính',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Danh sách chức năng
                  Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        _buildFunctionTile(
                          'Quản lý sản phẩm',
                          'Thêm, sửa, xóa sản phẩm',
                          Icons.inventory,
                          () => context.go(AdminRoutes.products),
                        ),
                        const Divider(height: 1),
                        _buildFunctionTile(
                          'Quản lý người dùng',
                          'Xem thông tin người dùng',
                          Icons.people,
                          () => context.go(AdminRoutes.users),
                        ),
                        const Divider(height: 1),
                        _buildFunctionTile(
                          'Quản lý đơn hàng',
                          'Xem và xử lý đơn hàng',
                          Icons.shopping_bag,
                          () => context.go(AdminRoutes.orders),
                        ),
                        const Divider(height: 1),
                        _buildFunctionTile(
                          'Quản lý danh mục',
                          'Thêm, sửa, xóa danh mục',
                          Icons.category,
                          () => context.go(AdminRoutes.categories),
                        ),
                        const Divider(height: 1),
                        _buildFunctionTile(
                          'Quản lý thể loại',
                          'Thêm, sửa, xóa thể loại',
                          Icons.class_,
                          () => context.go(AdminRoutes.genres),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Đơn hàng mới nhất
                  const Text(
                    'Đơn hàng mới nhất',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Mã ĐH',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Khách hàng',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Ngày đặt',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Tổng tiền',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Trạng thái',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          
                          // Placeholder for orders
                          _pendingOrders > 0
                              ? const Text('Có đơn hàng chờ xử lý')
                              : const Text('Không có đơn hàng mới'),
                          
                          const SizedBox(height: 16),
                          
                          // Xem tất cả
                          TextButton(
                            onPressed: () => context.go(AdminRoutes.orders),
                            child: const Text('Xem tất cả đơn hàng'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFunctionTile(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
} 