import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestionsPage extends StatelessWidget {
  const SuggestionsPage({super.key});

  void _showFeatureInDevelopment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang phát triển'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFC92127),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample book data (replace with actual data from your model later)
    final List<Map<String, dynamic>> books = [
      {
        'image': 'lib/core/assets/8935235241848.jpeg',
        'title': 'Hành Trình Về Phương Đông',
        'current_price': '90.500',
        'old_price': '118.000',
        'discount': '-23%',
        'sold': '652',
        'rating': null,
        'label': null,
      },
      {
        'image': 'lib/core/assets/2030xuhuonglon.jpg',
        'title': '25 Chuyên Đề Ngữ P...',
        'current_price': '86.500',
        'old_price': '110.000',
        'discount': '-21%',
        'sold': '185',
        'rating': '4.9',
        'label': 'Tập 1',
      },
      {
        'image': 'lib/core/assets/8935235237773.jpeg',
        'title': 'Giấy photo Double A...',
        'current_price': '106.950',
        'old_price': '118.000',
        'discount': '-9%',
        'sold': '1.2k',
        'rating': null,
        'label': 'FREESHIP 30K',
      },
      {
        'image': 'lib/core/assets/8935235234338.jpeg',
        'title': 'Prepare A2 Level 3 W...',
        'current_price': '113.050',
        'old_price': '119.000',
        'discount': '-5%',
        'sold': '205',
        'rating': null,
        'label': 'Level 3',
      },
      {
        'image': 'lib/core/assets/8934974182375.jpeg',
        'title': 'Cân Bằng Cảm Xúc',
        'current_price': '99.000',
        'old_price': '120.000',
        'discount': '-17%',
        'sold': '500',
        'rating': null,
        'label': null,
      },
      {
        'image': 'lib/core/assets/8934974180098_1.jpeg',
        'title': 'Thiết Kế Cuộc Đời',
        'current_price': '85.000',
        'old_price': '100.000',
        'discount': '-15%',
        'sold': '700',
        'rating': null,
        'label': null,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gợi ý cho bạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC92127),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.65,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return GestureDetector(
              onTap: () {
                _showFeatureInDevelopment(context);
                // context.push(
                //   '/home/product-detail',
                //   extra: {'image': book['image'], 'title': book['title']},
                // );
              },
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          book['image'],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (book['label'] != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                book['label'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              book['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${book['current_price']} đ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFFC92127),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      book['old_price'] + ' đ',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (book['discount'] != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC92127).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          book['discount'],
                                          style: const TextStyle(
                                            color: Color(0xFFC92127),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (book['rating'] != null) ...[
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        book['rating'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      'Đã bán ${book['sold']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 