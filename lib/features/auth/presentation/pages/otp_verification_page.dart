import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/auth_service.dart';
import 'package:bookstore/services/email_service.dart';
import 'package:bookstore/models/khach_hang.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bookstore/core/navigation/routes.dart';

class OtpVerificationPage extends StatefulWidget {
  final KhachHang khachHang;
  
  const OtpVerificationPage({
    super.key,
    required this.khachHang,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _timeLeft = 300; // 5 phút = 300 giây
  Timer? _timer;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  // Bắt đầu đếm ngược thời gian
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }
  
  // Định dạng thời gian còn lại
  String get _timeLeftFormatted {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Gửi lại mã OTP
  Future<void> _resendOTP() async {
    if (_isResending) return;
    
    setState(() {
      _isResending = true;
      _errorMessage = '';
    });
    
    try {
      final success = await EmailService.sendOTPEmail(
        widget.khachHang.email!,
        widget.khachHang.tenKhachHang!,
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mã OTP đã được gửi lại thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset thời gian
        setState(() {
          _timeLeft = 300;
          _timer?.cancel();
          _startTimer();
        });
      } else {
        setState(() {
          _errorMessage = 'Không thể gửi lại mã OTP. Vui lòng thử lại sau.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
      });
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }
  
  // Xác thực OTP và hoàn tất đăng ký
  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đủ 6 chữ số OTP';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Xác thực OTP
      final isValid = await EmailService.verifyOTP(
        widget.khachHang.email!,
        _otpController.text,
      );
      
      if (isValid) {
        // OTP hợp lệ, tiến hành đăng ký
        final result = await AuthService().register(widget.khachHang);
        
        if (result['success']) {
          // Gửi email xác nhận đăng ký thành công
          await EmailService.sendConfirmationEmail(
            widget.khachHang.email!,
            widget.khachHang.tenKhachHang!,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đăng ký thành công!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Chuyển hướng đến trang đăng nhập
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go(AppRoutes.login);
              }
            });
          }
        } else {
          setState(() {
            _errorMessage = result['message'] ?? 'Đăng ký thất bại';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
      });
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
      appBar: AppBar(
        title: Text('Xác thực OTP'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.email_outlined,
                size: 80,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                'Xác thực Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Chúng tôi đã gửi mã OTP đến email:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                widget.khachHang.email ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                'Nhập mã OTP 6 chữ số:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: Colors.grey,
                    selectedColor: AppColors.primaryColor,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = '';
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mã hết hạn sau: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    _timeLeftFormatted,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 60 ? Colors.red : AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Xác thực',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _timeLeft == 0 && !_isResending ? _resendOTP : null,
                child: _isResending
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                        ),
                      )
                    : Text(
                        _timeLeft > 0
                            ? 'Gửi lại mã sau $_timeLeftFormatted'
                            : 'Gửi lại mã OTP',
                        style: TextStyle(
                          color: _timeLeft > 0
                              ? Colors.grey
                              : AppColors.primaryColor,
                        ),
                      ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go(AppRoutes.register);
                },
                child: Text(
                  'Quay lại đăng ký',
                  style: TextStyle(color: AppColors.secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 