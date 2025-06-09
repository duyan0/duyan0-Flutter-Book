import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final TextInputType? keyboardType; // Thêm keyboardType

  const AuthTextField({
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.keyboardType, // Thêm vào constructor
    super.key,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isObscure = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    _isObscure = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscure && widget.obscureText,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType, // Truyền keyboardType
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _isFocused ? AppColors.primaryColor : AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                    widget.prefixIcon,
                    color:
                        _isFocused
                            ? AppColors.primaryColor
                            : AppColors.textColor,
                  )
                  : null,
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondaryColor, // #FFC107
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: AppColors.textColor.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.errorColor,
            ), // #D32F2F
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
          ),
        ),
        style: TextStyle(
          color: AppColors.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        validator: widget.validator,
      ),
    );
  }
}
