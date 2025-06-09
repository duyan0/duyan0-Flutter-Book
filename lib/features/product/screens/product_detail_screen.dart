// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bookstore/features/auth/presentation/pages/home_page.dart'; // Import HomePage
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:flutter/scheduler.dart'; // Import for SchedulerBinding

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  const ProductDetailScreen({super.key, required this.image, required this.title});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isDescriptionExpanded = false; // State variable for description expansion
  int _quantity = 0; // State variable for product quantity, initialized to 0
  late TextEditingController _quantityController; // Controller for quantity input

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      if (newQuantity < 0) {
        _quantity = 0;
      } else if (newQuantity > 100) {
        _quantity = 100;
      } else {
        _quantity = newQuantity;
      }
      _quantityController.text = _quantity.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // Use go_router to navigate directly to home page
          },
        ),
        title: Text('BookStore Giới Thiệu'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng tìm kiếm sẽ được phát triển sau.')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng giỏ hàng sẽ được phát triển sau.')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng menu sẽ được phát triển sau.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image and basic info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      widget.image, // Use the passed image
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.title, // Use the passed title
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '110.000 đ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text('5.0 (5)'),
                      SizedBox(width: 16),
                      Text('Đã bán 10k+', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Promotion codes
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Mã Giảm 10k - To...',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Mã Giảm 20k - T...',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            // Delivery and Return Policy
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.delivery_dining, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Dự kiến giao Thứ tư - 11/06'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Giao đến Phường Bến Nghé, Quận 1, Hồ Chí Minh', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.cached, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Đổi trả miễn phí toàn quốc 30 ngày - Gi...', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            // Product Type Selection
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn loại hàng (5 lựa chọn)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildProductTypeChip('Búp Sen Xanh'),
                        SizedBox(width: 8),
                        _buildProductTypeChip('Tiểu thuyết'),
                        SizedBox(width: 8),
                        _buildProductTypeChip('Truyện ngắn'),
                        SizedBox(width: 8),
                        _buildProductTypeChip('Văn học'),
                        SizedBox(width: 8),
                        _buildProductTypeChip('Sách tham khảo'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            // Product Ratings
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đánh giá sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text('5.0/5 (5 đánh giá)'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            // Product Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin sản phẩm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow('Mã hàng', '9786042253741'),
                  _buildInfoRow('Độ tuổi', '11 - 15'),
                  _buildInfoRow('Nhà cung cấp', 'Nhà Xuất Bản Kim Đồng'),
                  _buildInfoRow('Tác giả', 'Sơn Tùng'),
                  _buildInfoRow('Nhà xuất bản', 'Kim Đồng'),
                ],
              ),
            ),
            Divider(),
            // Product Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title, // Use the passed title
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '"Búp Sen Xanh" là cuốn tiểu thuyết nổi tiếng nhất của nhà văn Sơn Tùng - người đã dành trọn cuộc đời mình để viết về Bác Hồ và các vị anh hùng, nhưng những nhà cách mạng lỗi lạc của dân tộc. Tác phẩm "Búp Sen Xanh" kể về thời thơ ấu và một phần tuổi trẻ của Sơn Tùng, gắn liền với những biến cố lịch sử quan trọng của đất nước. Sách tái hiện lại một giai đoạn đầy biến động, nơi những lý tưởng cách mạng được ươm mầm và phát triển. Cuốn sách không chỉ là một tác phẩm văn học mà còn là một tài liệu lịch sử quý giá, giúp người đọc hiểu thêm về cuộc đời và sự nghiệp của những người đã làm nên lịch sử.',
                    maxLines: _isDescriptionExpanded ? null : 4, // Toggle maxLines
                    overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Text(_isDescriptionExpanded ? 'Thu gọn <' : 'Xem thêm >'), // Change text based on state
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80), // To make space for the bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.grey),
                      onPressed: () {
                        _updateQuantity(_quantity - 1);
                      },
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          int? parsedValue = int.tryParse(value);
                          if (parsedValue != null) {
                            _updateQuantity(parsedValue);
                          } else if (value.isEmpty) {
                            _updateQuantity(0);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        _updateQuantity(_quantity + 1);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thêm')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Thêm',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mua ngay $_quantity sản phẩm')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Mua ngay',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductTypeChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
} 