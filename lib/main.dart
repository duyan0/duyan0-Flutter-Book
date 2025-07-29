import 'package:flutter/material.dart';
import 'package:bookstore/core/navigation/app_router.dart';
import 'package:bookstore/core/navigation/admin_router.dart';
import 'package:bookstore/core/themes/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  // Sử dụng path URLs thay vì hash URLs cho web
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu đang chạy trên web và URL bắt đầu bằng /admin
    if (kIsWeb && Uri.base.path.startsWith('/admin')) {
      return MaterialApp.router(
        title: 'BookStore Admin',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AdminRouter.router,
      );
    }
    
    // Mặc định sử dụng router cho mobile app
    return MaterialApp.router(
      title: 'BookStore',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
