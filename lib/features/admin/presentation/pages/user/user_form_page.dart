import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookstore/models/user.dart';

class UserFormPage extends StatefulWidget {
  final int? userId; // Null nếu là tạo mới, có giá trị nếu là sửa

  const UserFormPage({super.key, this.userId});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;
  
  final _tenKhachHangController = TextEditingController();
  final _emailController = TextEditingController();
  final _taiKhoanController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _diaChiController = TextEditingController();
  bool _trangThai = true;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.userId != null;
    if (_isEditMode) {
      _loadUserData();
    }
  }
  
  @override
  void dispose() {
    _tenKhachHangController.dispose();
    _emailController.dispose();
    _taiKhoanController.dispose();
    _matKhauController.dispose();
    _soDienThoaiController.dispose();
    _diaChiController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await AdminService().getUserById(widget.userId!);
      
      if (result['success'] && result['data'] != null) {
        final userData = result['data'];
        
        setState(() {
          _tenKhachHangController.text = userData['tenKhachHang'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _taiKhoanController.text = userData['taiKhoan'] ?? '';
          _soDienThoaiController.text = userData['soDienThoai'] ?? '';
          _diaChiController.text = userData['diaChi'] ?? '';
          _trangThai = userData['trangThai'] ?? true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final userData = {
      'tenKhachHang': _tenKhachHangController.text,
      'email': _emailController.text,
      'taiKhoan': _taiKhoanController.text,
      'soDienThoai': _soDienThoaiController.text,
      'diaChi': _diaChiController.text,
      'trangThai': _trangThai,
    };
    
    // Thêm mật khẩu nếu đang tạo mới hoặc có nhập mật khẩu mới
    if (!_isEditMode || _matKhauController.text.isNotEmpty) {
      userData['matKhau'] = _matKhauController.text;
    }
    
    try {
      final Map<String, dynamic> result;
      
      if (_isEditMode) {
        result = await AdminService().updateUser(widget.userId!, userData);
      } else {
        result = await AdminService().createUser(userData);
      }
      
      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode ? 'Cập nhật thành công' : 'Thêm mới thành công'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Quay về trang danh sách
          context.pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: _isEditMode ? 'Sửa thông tin người dùng' : 'Thêm người dùng mới',
      ),
      drawer: AdminDrawer(currentPath: AdminRoutes.users),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _tenKhachHangController,
                        label: 'Họ tên',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập họ tên';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _taiKhoanController,
                        label: 'Tài khoản',
                        enabled: !_isEditMode, // Không cho phép sửa tài khoản
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tài khoản';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _matKhauController,
                        label: _isEditMode ? 'Mật khẩu mới (để trống nếu không đổi)' : 'Mật khẩu',
                        obscureText: true,
                        validator: (value) {
                          if (!_isEditMode && (value == null || value.isEmpty)) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _soDienThoaiController,
                        label: 'Số điện thoại',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _diaChiController,
                        label: 'Địa chỉ',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Trạng thái tài khoản'),
                        subtitle: Text(_trangThai ? 'Hoạt động' : 'Khóa'),
                        value: _trangThai,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _trangThai = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => context.pop(),
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _saveUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
                            child: Text(_isEditMode ? 'Cập nhật' : 'Thêm mới'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
} 