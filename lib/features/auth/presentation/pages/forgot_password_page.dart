import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
                          'Khôi phục tài khoản',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tiêu đề phụ
                        Text(
                          'Nhập email để nhận liên kết đặt lại mật khẩu',
                          style: TextStyle(
                            color: AppColors.textColor, // #333333
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Nút gửi yêu cầu
                        SizedBox(
                          width: double.infinity, // Đồng bộ với LoginPage
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Xử lý gửi email reset mật khẩu (giả lập)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Liên kết đặt lại đã được gửi!',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primaryColor, // #C92127
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15, // Đồng bộ với LoginPage
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Gửi yêu cầu',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Quay lại đăng nhập
                        TextButton(
                          onPressed: () => context.push(AppRoutes.login),
                          child: Text(
                            'Quay lại đăng nhập',
                            style: TextStyle(
                              color: AppColors.secondaryColor, // #FFC107
                              fontWeight: FontWeight.w600,
                              fontSize: 14, // Đồng bộ với LoginPage
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
