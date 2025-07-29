import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import 'package:bookstore/services/auth_service.dart';
import 'package:bookstore/services/email_service.dart';
import 'package:bookstore/models/khach_hang.dart';
import '../widgets/auth_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import 'otp_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final taiKhoanController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    taiKhoanController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Tạo đối tượng khách hàng
      final khachHang = KhachHang(
        tenKhachHang: nameController.text.trim(),
        email: emailController.text.trim(),
        taiKhoan: taiKhoanController.text.trim(),
        matKhau: passwordController.text,
        soDienThoai: phoneController.text.trim(),
        trangThai: true,
      );

      // Kiểm tra tài khoản đã tồn tại chưa
      final checkResult = await AuthService().checkUserExists(taiKhoanController.text.trim());
      
      if (checkResult['exists']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tài khoản đã tồn tại!'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
      
      // Kiểm tra email đã tồn tại chưa
      final checkEmailResult = await AuthService().checkEmailExists(emailController.text.trim());
      
      if (checkEmailResult['exists']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email đã được sử dụng!'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // Gửi email OTP
      final sendResult = await EmailService.sendOTPEmail(
        emailController.text.trim(),
        nameController.text.trim(),
      );

      if (sendResult) {
        // Chuyển đến trang xác thực OTP
        if (mounted) {
          context.push(AppRoutes.otpVerification, extra: khachHang);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể gửi mã OTP. Vui lòng thử lại sau.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
      backgroundColor: AppColors.backgroundColor,
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
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        // Tiêu đề
                        Text(
                          'Tham gia BookStore',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
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
                            if (!RegExp(r'^[\p{L}\s]+$', unicode: true).hasMatch(value)) {
                              return 'Họ tên chỉ chứa chữ cái và dấu cách';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Trường Tài khoản
                        AuthTextField(
                          label: 'Tài khoản',
                          prefixIcon: Icons.account_circle,
                          controller: taiKhoanController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tài khoản';
                            }
                            if (value.length < 3) {
                              return 'Tài khoản phải có ít nhất 3 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                            if (!RegExp(r'^(?:\+84|0)(?:3|5|7|8|9)\d{8}$').hasMatch(value)) {
                              return 'Số điện thoại không hợp lệ (VD: +84912345678)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Trường Email
                        AuthTextField(
                          label: 'Email',
                          prefixIcon: Icons.email,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Trường Mật khẩu
                        AuthTextField(
                          label: 'Mật khẩu',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock,
                          controller: passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
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
                        const SizedBox(height: 16),
                        // Trường Xác nhận mật khẩu
                        AuthTextField(
                          label: 'Xác nhận mật khẩu',
                          obscureText: _obscureConfirmPassword,
                          prefixIcon: Icons.lock,
                          controller: confirmPasswordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
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
                        const SizedBox(height: 12),
                        // Đã có tài khoản
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => context.push(AppRoutes.login),
                              child: Text(
                                'Đã có tài khoản? Đăng nhập',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Nút Đăng ký
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Đăng ký',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Nút Đăng ký bằng Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : () {
                              // Xử lý đăng ký Google (giả lập)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tính năng đang phát triển!'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.g_mobiledata,
                              color: AppColors.textColor,
                            ),
                            label: Text(
                              'Đăng ký bằng Google',
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
