import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // #F5F5F5
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Form(
                  key: formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo sách
                        Icon(
                          Icons.book,
                          size: 80,
                          color: AppColors.primaryColor, // #C92127
                        ),
                        const SizedBox(height: 16),
                        // Tiêu đề
                        Text(
                          'Đăng nhập vào BookStore',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Trường email
                        AuthTextField(
                          label: 'Email',
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Trường mật khẩu
                        AuthTextField(
                          label: 'Mật khẩu',
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // Quên mật khẩu và Đăng ký trên cùng hàng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed:
                                  () => context.push(AppRoutes.forgotPassword),
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: AppColors.secondaryColor, // #FFC107
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push(AppRoutes.register),
                              child: Text(
                                'Chưa có tài khoản? Đăng ký',
                                style: TextStyle(
                                  color: AppColors.secondaryColor, // #FFC107
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Nút đăng nhập
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Hiển thị thông báo
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đăng nhập thành công!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                // Chuyển hướng đến HomePage sau 1 giây
                                Future.delayed(const Duration(seconds: 1), () {
                                  // ignore: use_build_context_synchronously
                                  context.go(AppRoutes.home);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primaryColor, // #C92127
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Nút đăng nhập bằng Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Xử lý đăng nhập Google (giả lập)
                            },
                            icon: Icon(
                              Icons.g_mobiledata,
                              color: AppColors.textColor,
                            ),
                            label: Text(
                              'Đăng nhập bằng Google',
                              style: TextStyle(color: AppColors.textColor),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15,
                              ),
                              side: BorderSide(color: AppColors.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
