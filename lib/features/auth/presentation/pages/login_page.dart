import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Đăng nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthTextField(
              label: 'Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Mật khẩu',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng nhập (giả lập)
              },
              child: const Text('Đăng nhập'),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.forgotPassword),
              child: Text(
                'Quên mật khẩu?',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: Text(
                'Chưa có tài khoản? Đăng ký',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
