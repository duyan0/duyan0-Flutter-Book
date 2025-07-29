import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/services/cart_service.dart';
import 'package:intl/intl.dart';

class BookDetailPage extends StatelessWidget {
  final Product product;

  const BookDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final price = product.price != null ? formatter.format(product.price) : '0₫';
    final discountedPrice = product.giaSauGiam != null && product.giaSauGiam != product.price
        ? formatter.format(product.giaSauGiam)
        : null;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFC92127),
        title: const Text(
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
              color: Colors.white,
              child: product.hinhAnhUrl != null
                ? Image.network(
                    product.hinhAnhUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
                      );
                    },
                  )
                : Center(
                    child: Icon(Icons.book, size: 64, color: Colors.grey[400]),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và tác giả
                  Text(
                    product.title ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tác giả: ${product.author?.name ?? 'Không có thông tin'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Giá sản phẩm
                  Row(
                    children: [
                      Text(
                        discountedPrice ?? price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC92127),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (discountedPrice != null)
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (product.phanTramGiamGia != null && product.phanTramGiamGia! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${product.phanTramGiamGia!.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Trạng thái
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.conHang ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.status ?? (product.conHang ? 'Còn hàng' : 'Hết hàng'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Thông tin chi tiết
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Danh mục', product.category?.name ?? 'Không có thông tin'),
                  _buildInfoRow('Nhà xuất bản', product.publisher?.name ?? 'Không có thông tin'),
                  _buildInfoRow('Số trang', '${product.pageCount ?? 0} trang'),
                  _buildInfoRow('Ngày xuất bản', product.publicationDate != null 
                      ? DateFormat('dd/MM/yyyy').format(product.publicationDate!) 
                      : 'Không có thông tin'),
                  _buildInfoRow('Ngôn ngữ', product.language ?? 'Không có thông tin'),
                  _buildInfoRow('ISBN', product.isbn ?? 'Không có thông tin'),
                  const SizedBox(height: 16),

                  // Mô tả
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'Không có mô tả',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút mua hàng
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: product.conHang ? () {
                        // Thêm vào giỏ hàng
                        CartService.addToCart(product, 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã thêm vào giỏ hàng'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC92127),
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        product.conHang 
                            ? 'Thêm vào giỏ hàng - $price' 
                            : 'Hết hàng',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 