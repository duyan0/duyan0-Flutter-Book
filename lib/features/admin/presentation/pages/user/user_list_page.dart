import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookstore/models/user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool _isLoading = true;
  List<User> _users = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalUsers = 0;
  int _totalPages = 1;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print('Đang gọi API lấy danh sách user...');
      final result = await AdminService().getUsers(
        page: _currentPage,
        pageSize: _pageSize,
      );
      print('API Response: $result');
      
      if (result['success'] && result['data'] != null) {
        final data = result['data'];
        print('Data structure: ${data.keys}');
        
        List<User> users = [];
        
        // Kiểm tra cấu trúc data.data.items.$values
        if (data['data'] != null && data['data']['items'] != null && data['data']['items']['\$values'] != null) {
          print('Items found in data.data.items');
          final List usersJson = data['data']['items']['\$values'];
          print('Values found: ${usersJson.length}');
          
          try {
            // In ra mẫu JSON đầu tiên để debug
            if (usersJson.isNotEmpty) {
              print('Sample user JSON: ${usersJson[0]}');
            }
            
            users = usersJson.map((json) {
              try {
                return User.fromJson(json);
              } catch (e) {
                print('Error parsing user: $e');
                print('User JSON: $json');
                return null;
              }
            }).whereType<User>().toList();
            
            print('Parsed ${users.length} users successfully');
          } catch (e) {
            print('Error mapping users: $e');
          }
        } else {
          print('No items or \$values found in data');
          print('Data structure: $data');
        }
        
        // Lấy tổng số từ pagination trong data.data
        _totalUsers = data['data']?['pagination']?['totalCount'] ?? users.length;
        _totalPages = (_totalUsers / _pageSize).ceil();
        
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          users = users.where((user) {
            final name = user.tenKhachHang?.toLowerCase() ?? '';
            final email = user.email?.toLowerCase() ?? '';
            final username = user.taiKhoan?.toLowerCase() ?? '';
            return name.contains(query) || email.contains(query) || username.contains(query);
          }).toList();
        }
        
        print('Final users list: ${users.length} users');
        setState(() {
          _users = users;
          _isLoading = false;
        });
      } else {
        print('API call failed: ${result['message']}');
        setState(() {
          _users = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Exception in _loadUsers: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _search() {
    _currentPage = 1;
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go(AdminRoutes.userCreate),
          ),
        ],
      ),
      drawer: AdminDrawer(currentPath: AdminRoutes.users),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm người dùng...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                    },
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Text('Tìm kiếm'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng số: $_totalUsers người dùng',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/admin/users/create');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm người dùng'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                    ? const Center(child: Text('Không có người dùng nào'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 2,
                          child: ListView(
                            children: [
                              Container(
                                color: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 50, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 16),
                                    Expanded(flex: 2, child: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 120, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              ...List.generate(
                                _users.length,
                                (index) => _buildUserRow(_users[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          if (!_isLoading && _totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                            _loadUsers();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 16),
                  Text('Trang $_currentPage / $_totalPages'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _currentPage < _totalPages
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                            _loadUsers();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserRow(User user) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(width: 50, child: Text('${user.maKhachHang}')),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: Text(user.tenKhachHang ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(child: Text(user.email ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(child: Text(user.taiKhoan ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (user.trangThai == true) ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.trangThai == true ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: (user.trangThai == true) ? Colors.green[800] : Colors.red[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      context.go(
                        AdminRoutes.userEdit,
                        extra: {'userId': user.maKhachHang},
                      );
                    },
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(user);
                    },
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa người dùng "${user.tenKhachHang ?? user.taiKhoan}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user.maKhachHang!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(int userId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AdminService().deleteUser(userId);
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa người dùng thành công'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Tải lại danh sách người dùng
        _loadUsers();
      } else {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 