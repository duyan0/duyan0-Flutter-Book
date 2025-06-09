import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';

class BookCategoriesSection extends StatelessWidget {
  final bool isLoading;

  const BookCategoriesSection({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh mục sách',
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
                    content: Text('Xem tất cả danh mục'),
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
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              {
                'name': 'Văn học',
                'image': 'lib/core/assets/hks_1.jpeg',
              },
              {
                'name': 'Khoa học',
                'image': 'lib/core/assets/hks_1.jpeg',
              },
              {
                'name': 'Kinh tế',
                'image': 'lib/core/assets/hks_1.jpeg',
              },
              {
                'name': 'Thiếu nhi',
                'image': 'lib/core/assets/hks_1.jpeg',
              },
              {
                'name': 'Tự truyện',
                'image': 'lib/core/assets/hks_1.jpeg',
              },
            ].map((category) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Danh mục: ${category['name']}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(category['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isLoading)
                            Container(
                              height: 60,
                              width: 60,
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name']!,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
} 