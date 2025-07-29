import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailService {
  // Thông tin SMTP server cho Gmail
  static final smtpServer = gmail('crandi21112004@gmail.com', 'tmhq jaun uzrm occv');
  
  // Tạo mã OTP ngẫu nhiên 6 chữ số
  static String generateOTP() {
    return randomNumeric(6);
  }
  
  // Lưu OTP vào SharedPreferences để xác thực sau này
  static Future<void> saveOTP(String email, String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('otp_$email', otp);
    
    // Thiết lập thời gian hết hạn (5 phút)
    final expiry = DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch;
    await prefs.setInt('otp_expiry_$email', expiry);
  }
  
  // Xác thực OTP
  static Future<bool> verifyOTP(String email, String otp) async {
    final prefs = await SharedPreferences.getInstance();
    final savedOTP = prefs.getString('otp_$email');
    final expiry = prefs.getInt('otp_expiry_$email');
    
    if (savedOTP == null || expiry == null) {
      return false;
    }
    
    // Kiểm tra thời gian hết hạn
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > expiry) {
      // OTP đã hết hạn
      await prefs.remove('otp_$email');
      await prefs.remove('otp_expiry_$email');
      return false;
    }
    
    // Kiểm tra OTP có khớp không
    if (savedOTP == otp) {
      // Xóa OTP sau khi xác thực thành công
      await prefs.remove('otp_$email');
      await prefs.remove('otp_expiry_$email');
      return true;
    }
    
    return false;
  }
  
  // Gửi email OTP
  static Future<bool> sendOTPEmail(String email, String name) async {
    try {
      // Tạo OTP
      final otp = generateOTP();
      
      // Lưu OTP để xác thực sau này
      await saveOTP(email, otp);
      
      // Tạo nội dung email
      final message = Message()
        ..from = Address('your_email@gmail.com', 'BookStore')
        ..recipients.add(email)
        ..subject = 'Xác thực đăng ký tài khoản BookStore'
        ..html = '''
          <h2>Chào $name,</h2>
          <p>Cảm ơn bạn đã đăng ký tài khoản tại BookStore.</p>
          <p>Mã xác thực OTP của bạn là: <strong style="font-size: 20px; color: #C92127;">$otp</strong></p>
          <p>Mã này sẽ hết hạn sau 5 phút.</p>
          <p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>
          <p>Trân trọng,<br>Đội ngũ BookStore</p>
        ''';
      
      // Gửi email
      final sendReport = await send(message, smtpServer);
      print('📧 Email đã được gửi: ${sendReport.toString()}');
      
      return true;
    } catch (e) {
      print('❌ Lỗi khi gửi email: $e');
      return false;
    }
  }
  
  // Gửi email xác nhận đăng ký thành công
  static Future<bool> sendConfirmationEmail(String email, String name) async {
    try {
      // Tạo nội dung email
      final message = Message()
        ..from = Address('crandi21112004@gmail.com', 'BookStore')
        ..recipients.add(email)
        ..subject = 'Đăng ký tài khoản thành công'
        ..html = '''
          <h2>Chào $name,</h2>
          <p>Chúc mừng! Bạn đã đăng ký tài khoản thành công tại BookStore.</p>
          <p>Bạn có thể đăng nhập ngay bây giờ để trải nghiệm dịch vụ của chúng tôi.</p>
          <p>Trân trọng,<br>Đội ngũ BookStore</p>
        ''';
      
      // Gửi email
      final sendReport = await send(message, smtpServer);
      print('📧 Email xác nhận đã được gửi: ${sendReport.toString()}');
      
      return true;
    } catch (e) {
      print('❌ Lỗi khi gửi email xác nhận: $e');
      return false;
    }
  }
} 