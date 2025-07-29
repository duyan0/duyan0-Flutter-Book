import 'package:bookstore/core/navigation/admin_router.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Bắt đầu animation
    _controller.forward();

    // Chuyển hướng sau 2 giây
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Thử cách chuyển hướng khác
        context.go('/home');
        //context.go(AdminRoutes.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng sạch sẽ
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, // Đổi thành trắng để loại bỏ xám xám
            borderRadius: BorderRadius.circular(16),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo sách
                  Icon(
                    Icons.book,
                    size: 80,
                    color: AppColors.primaryColor, // #C92127
                  ),
                  const SizedBox(height: 16),
                  // Tên ứng dụng
                  Text(
                    'BookStore',
                    style: TextStyle(
                      color: AppColors.primaryColor, // #C92127
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Slogan
                  Text(
                    'Quản lý tri thức, kết nối yêu sách',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0), // #333333
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Loading indicator
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor, // #C92127
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
