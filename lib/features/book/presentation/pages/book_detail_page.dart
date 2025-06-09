import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';

class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int pages;
  final String publisher;
  final DateTime publishDate;
  final double rating;
  final int reviewCount;

  const BookDetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.pages,
    required this.publisher,
    required this.publishDate,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Chi tiết sách',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa sách
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và tác giả
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tác giả: $author',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Đánh giá
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($reviewCount đánh giá)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Thông tin chi tiết
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Danh mục', category),
                  _buildInfoRow('Nhà xuất bản', publisher),
                  _buildInfoRow('Số trang', '$pages trang'),
                  _buildInfoRow('Ngày xuất bản', '${publishDate.day}/${publishDate.month}/${publishDate.year}'),
                  const SizedBox(height: 16),

                  // Mô tả
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút mua hàng
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã thêm vào giỏ hàng'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Mua ngay - ${price.toStringAsFixed(0)} VNĐ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
} 