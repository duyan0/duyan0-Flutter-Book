import 'package:flutter/material.dart';

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.calendar_today, 'label': 'D.Day 15.06'},
      {'icon': Icons.flash_on, 'label': 'Flash Sale'},
      {'icon': Icons.business, 'label': 'Bình Tây'},
      {'icon': Icons.business_center, 'label': 'Vĩnh Thịnh'},
      {'icon': Icons.discount, 'label': 'Mã Giảm Giá'},
      {'icon': Icons.fiber_new, 'label': 'Sản Phẩm Mới'},
      {'icon': Icons.percent, 'label': 'Sản Phẩm Được Trợ Giá'},
      {'icon': Icons.store, 'label': 'Phiên Chợ Đồ Cũ'},
      {'icon': Icons.local_shipping, 'label': 'Bán Sỉ'},
      {'icon': Icons.pets, 'label': 'Manga'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.85,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return SizedBox(
            height: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Icon(item['icon'], color: Color(0xFFC92127), size: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  item['label'],
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 