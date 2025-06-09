import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/features/product/screens/product_detail_screen.dart';
import 'package:go_router/go_router.dart';

class BestSellingBooksSection extends StatelessWidget {
  final bool isLoading;

  const BestSellingBooksSection({
    super.key,
    required this.isLoading,
  });

  void _showBookDetails(BuildContext context, String title) {
    final List<Map<String, dynamic>> _bestSellingBooks = [
      {
        'image': 'lib/core/assets/8935235241848.jpeg',
        'title': 'Tên sách bán chạy 1',
        'price': 95000,
      },
      {
        'image': 'lib/core/assets/8935235237773.jpeg',
        'title': 'Tên sách bán chạy 2',
        'price': 120000,
      },
      {
        'image': 'lib/core/assets/8935235234338.jpeg',
        'title': 'Tên sách bán chạy 3',
        'price': 80000,
      },
      {
        'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
        'title': 'Tên sách bán chạy 4',
        'price': 110000,
      },
      {
        'image': 'lib/core/assets/8934974182375.jpeg',
        'title': 'Tên sách bán chạy 5',
        'price': 75000,
      },
      {
        'image': 'lib/core/assets/8934974180098_1.jpeg',
        'title': 'Tên sách bán chạy 6',
        'price': 105000,
      },
      {
        'image': 'lib/core/assets/hks_1.jpeg',
        'title': 'Tên sách bán chạy 7',
        'price': 90000,
      },
    ];

    // Find the book in _bestSellingBooks list based on title
    final selectedBook = _bestSellingBooks.firstWhere(
        (book) => book['title'] == title,
        orElse: () => { 'image': 'lib/core/assets/hks_1.jpeg', 'title': title }); // Fallback

    context.push(
      '/home/product-detail',
      extra: {
        'image': selectedBook['image'],
        'title': selectedBook['title']
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _bestSellingBooks = [
      {
        'image': 'lib/core/assets/8935235241848.jpeg',
        'title': 'Tên sách bán chạy 1',
        'price': 95000,
      },
      {
        'image': 'lib/core/assets/8935235237773.jpeg',
        'title': 'Tên sách bán chạy 2',
        'price': 120000,
      },
      {
        'image': 'lib/core/assets/8935235234338.jpeg',
        'title': 'Tên sách bán chạy 3',
        'price': 80000,
      },
      {
        'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
        'title': 'Tên sách bán chạy 4',
        'price': 110000,
      },
      {
        'image': 'lib/core/assets/8934974182375.jpeg',
        'title': 'Tên sách bán chạy 5',
        'price': 75000,
      },
      {
        'image': 'lib/core/assets/8934974180098_1.jpeg',
        'title': 'Tên sách bán chạy 6',
        'price': 105000,
      },
      {
        'image': 'lib/core/assets/hks_1.jpeg',
        'title': 'Tên sách bán chạy 7',
        'price': 90000,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sản phẩm bán chạy',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Xem tất cả sách bán chạy'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _bestSellingBooks.length,
            itemBuilder: (context, index) {
              final book = _bestSellingBooks[index];
              return GestureDetector(
                onTap: () => _showBookDetails(context, book['title']),
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(book['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isLoading)
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã thêm ${book['title']} vào giỏ hàng'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book['title'],
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${book['price'].toStringAsFixed(0)} VNĐ',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 