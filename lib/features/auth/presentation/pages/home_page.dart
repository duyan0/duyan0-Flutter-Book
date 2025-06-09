import 'package:flutter/material.dart';
import 'package:bookstore/features/auth/presentation/widgets/home_app_bar.dart';
import 'package:bookstore/features/auth/presentation/widgets/home_banner.dart';
import 'package:bookstore/features/auth/presentation/widgets/home_menu_grid.dart';
import 'package:bookstore/features/auth/presentation/widgets/flash_sale_section.dart';
import 'package:bookstore/features/auth/presentation/widgets/book_tab_view_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeBanner(),
            const SizedBox(height: 8),
            const HomeMenuGrid(),
            const SizedBox(height: 16),
            const FlashSaleSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'lib/core/assets/banner_1.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const BookTabViewSection(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xem thêm sách'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC92127),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFC92127)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Xem thêm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
