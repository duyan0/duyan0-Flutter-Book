import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Quên mật khẩu'),
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
            ElevatedButton(
              onPressed: () {
                // Xử lý gửi email reset mật khẩu (giả lập)
              },
              child: const Text('Gửi yêu cầu'),
            ),
          ],
        ),
      ),
    );
  }
}
