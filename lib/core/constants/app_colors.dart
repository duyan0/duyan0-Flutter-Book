import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(
    0xffc92127,
  ); // Màu chính // FF là độ trong suốt
  static const Color secondaryColor = Color(0xFFFFC107); // Màu phụ
  static const Color backgroundColor = Color(0xFFF5F5F5); // Màu nền
  static const Color textColor = Color(0xFF333333); // Màu chữ
  static const Color errorColor = Color(0xFFD32F2F); // Màu lỗi

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007BFF), Color(0xFF00C4B4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
