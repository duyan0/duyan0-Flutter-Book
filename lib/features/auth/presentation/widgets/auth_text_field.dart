import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textColor),
      ),
      validator: validator,
    );
  }
}
