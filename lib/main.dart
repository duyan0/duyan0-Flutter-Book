import 'package:flutter/material.dart';
import 'core/navigation/app_router.dart';
import 'core/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Auth App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
