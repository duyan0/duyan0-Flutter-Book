import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // #F5F5F5
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding =
              constraints.maxWidth > 600 ? 32.0 : 16.0; // Đồng bộ với LoginPage
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Form(
                  key: formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400, // Đồng bộ với LoginPage
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo sách
                        Icon(
                          Icons.book,
                          size: 80, // Đồng bộ với LoginPage
                          color: AppColors.primaryColor, // #C92127
                        ),
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Tiêu đề
                        Text(
                          'Tham gia BookStore',
                          style: TextStyle(
                            color: AppColors.primaryColor, // #C92127
                            fontSize: 24, // Đồng bộ với LoginPage
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora',
                          ),
                        ),
                        const SizedBox(height: 8), // Giữ nguyên
                        // Trường Họ Tên
                        AuthTextField(
                          label: 'Họ Tên',
                          prefixIcon: Icons.person,
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập họ tên';
                            }
                            if (value.length < 2) {
                              return 'Họ tên phải có ít nhất 2 ký tự';
                            }
                            if (!RegExp(
                              r'^[\p{L}\s]+$',
                              unicode: true,
                            ).hasMatch(value)) {
                              return 'Họ tên chỉ chứa chữ cái và dấu cách';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Trường Số điện thoại
                        AuthTextField(
                          label: 'Số điện thoại',
                          prefixIcon: Icons.phone,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
                            }
                            if (!RegExp(
                              r'^(?:\+84|0)(?:3|5|7|8|9)\d{8}$',
                            ).hasMatch(value)) {
                              return 'Số điện thoại không hợp lệ (VD: +84912345678)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Trường Email
                        AuthTextField(
                          label: 'Email',
                          prefixIcon: Icons.email,
                          controller: emailController,
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
                        // Trường Mật khẩu
                        AuthTextField(
                          label: 'Mật khẩu',
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          controller: passwordController,
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
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Trường Xác nhận mật khẩu
                        AuthTextField(
                          label: 'Xác nhận mật khẩu',
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu';
                            }
                            if (value != passwordController.text) {
                              return 'Mật khẩu không khớp';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12), // Đồng bộ với LoginPage
                        // Đã có tài khoản trên cùng hàng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 0), // Placeholder
                            TextButton(
                              onPressed: () => context.push(AppRoutes.login),
                              child: Text(
                                'Đã có tài khoản? Đăng nhập',
                                style: TextStyle(
                                  color: AppColors.secondaryColor, // #FFC107
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14, // Đồng bộ với LoginPage
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Đồng bộ với LoginPage
                        // Nút Đăng ký
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đăng ký thành công!'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primaryColor, // #C92127
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15,
                              ), // Đồng bộ với LoginPage
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontSize: 16,
                              ), // Đồng bộ với LoginPage
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Đồng bộ với LoginPage
                        // Nút Đăng ký bằng Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Xử lý đăng ký Google (giả lập)
                            },
                            icon: Icon(
                              Icons.g_mobiledata,
                              color: AppColors.textColor,
                            ), // Đồng bộ với LoginPage
                            label: Text(
                              'Đăng ký bằng Google',
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15,
                              ), // Đồng bộ với LoginPage
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
