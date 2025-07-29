import 'package:flutter/material.dart';
import 'package:bookstore/services/auth_service.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;

  const AdminGuard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    if (!authService.canAccessAdminPages()) {
      // Nếu không phải admin, chuyển về trang chủ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn không có quyền truy cập trang này'),
            backgroundColor: Colors.red,
          ),
        );
      });
      
      // Trả về loading screen trong khi chuyển trang
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Nếu là admin, hiển thị trang được yêu cầu
    return child;
  }
} 