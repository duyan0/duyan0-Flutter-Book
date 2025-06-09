import 'package:flutter/material.dart';
import 'dart:async';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  Duration _duration = const Duration(hours: 1, minutes: 41, seconds: 14);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    ) + ' đ';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> books = [
      {
        'image': 'lib/core/assets/8935235241848.jpeg',
        'title': 'Trốn Lên Mái Nhà Để Khóc',
        'originalPrice': 120000,
        'salePrice': 84000,
        'discount': 30,
        'sold': '100+',
      },
      {
        'image': 'lib/core/assets/8935235237773.jpeg',
        'title': 'Thay Lời Muốn Nói - Thanh Xuân Tôi',
        'originalPrice': 95000,
        'salePrice': 67000,
        'discount': 29,
        'sold': '80+',
      },
      {
        'image': 'lib/core/assets/8935235234338.jpeg',
        'title': 'Cổ Tích Cho Bé',
        'originalPrice': 60000,
        'salePrice': 42000,
        'discount': 30,
        'sold': '150+',
      },
      {
        'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
        'title': 'Dạy Con Làm Giàu',
        'originalPrice': 150000,
        'salePrice': 105000,
        'discount': 30,
        'sold': '200+',
      },
    ];
    String h = _duration.inHours.remainder(100).toString().padLeft(2, '0');
    String m = _duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String s = _duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Container(
      color: const Color(0xFFFFEAEA),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'FLASH SALE',
                  style: TextStyle(
                    color: Color(0xFFC92127),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 12),
                _buildTimerBox(h),
                const SizedBox(width: 4),
                _buildTimerBox(m),
                const SizedBox(width: 4),
                _buildTimerBox(s),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 290,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: books.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          book['image'],
                          height: 120,
                          width: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  _formatCurrency(book['originalPrice']),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF424E),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${book['discount']}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatCurrency(book['salePrice']),
                              style: const TextStyle(
                                color: Color(0xFFC92127),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Đã bán ${book['sold']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  elevation: 0,
                                  side: const BorderSide(color: Color(0xFFC92127), width: 1.5),
                                  foregroundColor: const Color(0xFFC92127),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Mua ngay',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTimerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
} 