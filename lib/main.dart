import 'package:flutter/material.dart';
import 'package:bookstore/core/navigation/app_router.dart';
import 'package:bookstore/core/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookStore',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false, // Tắt banner DEBUG
      routerConfig: router,
    );
  }
}
