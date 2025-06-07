import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Đăng ký'),
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
            AuthTextField(
              label: 'Xác nhận mật khẩu',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận mật khẩu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng ký (giả lập)
              },
              child: const Text('Đăng ký'),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.login),
              child: Text(
                'Đã có tài khoản? Đăng nhập',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
