// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bookstore/features/auth/presentation/pages/home_page.dart'; // Import HomePage
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:flutter/scheduler.dart'; // Import for SchedulerBinding
import 'package:bookstore/models/product.dart';
import 'package:bookstore/services/product_service.dart';
import 'package:bookstore/services/order_service.dart';
import 'package:bookstore/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product?> _productFuture;
  bool _isDescriptionExpanded = false;
  int _quantity = 1;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.getProductById(widget.productId);
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      if (newQuantity < 1) {
        _quantity = 1;
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
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(body: Center(child: Text('Không tìm thấy sản phẩm')));
        }
        final product = snapshot.data!;
        
        // Calculate discount information
        final bool hasDiscount = product.promotion != null && 
                               product.promotion!.discount != null && 
                               product.promotion!.discount! > 0 &&
                               product.promotion!.isActive;
        final double originalPrice = product.price ?? 0;
        final double discountPercent = hasDiscount ? product.promotion!.discount! : 0;
        final double discountedPrice = hasDiscount ? originalPrice * (1 - discountPercent / 100) : originalPrice;
        final double savedAmount = hasDiscount ? originalPrice - discountedPrice : 0;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/home');
              },
            ),
            title: Text(product.title ?? ''),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
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
                      Stack(
                        children: [
                          Center(
                            child: product.image != null
                                ? Image.network(
                                    product.image!,
                                    height: 300,
                                    fit: BoxFit.contain,
                                  )
                                : Container(
                                    height: 300,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image, size: 80, color: Colors.grey),
                                  ),
                          ),
                          if (hasDiscount)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${discountPercent.toInt()}%',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        product.title ?? '',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Price and discount information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Original price (if discounted)
                          if (hasDiscount)
                            Row(
                              children: [
                                Text(
                                  'Giá gốc: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  _formatCurrency(originalPrice),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 4),
                          // Current price
                          Row(
                            children: [
                              Text(
                                hasDiscount ? 'Giá khuyến mãi: ' : 'Giá: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatCurrency(discountedPrice),
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                              SizedBox(width: 8),
                              if (hasDiscount)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${discountPercent.toInt()}%',
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          // Amount saved
                          if (hasDiscount)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Tiết kiệm: ${_formatCurrency(savedAmount)}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(product.status ?? '', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          SizedBox(width: 16),
                          Text('Còn lại: ${product.quantity ?? 0}', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('ISBN:', product.isbn ?? ''),
                      _buildInfoRow('Số trang:', product.pageCount?.toString() ?? ''),
                      _buildInfoRow('Ngôn ngữ:', product.language ?? ''),
                      _buildInfoRow('Ngày xuất bản:', product.publicationDate != null ? _formatDate(product.publicationDate!) : ''),
                      _buildInfoRow('Danh mục:', product.category?.name ?? ''),
                      _buildInfoRow('Tác giả:', product.author?.name ?? ''),
                      _buildInfoRow('Quốc gia:', product.author?.country ?? ''),
                      _buildInfoRow('Nhà xuất bản:', product.publisher?.name ?? ''),
                      _buildInfoRow('Địa chỉ NXB:', product.publisher?.address ?? ''),
                      _buildInfoRow('SĐT NXB:', product.publisher?.phone ?? ''),
                      _buildInfoRow('Email NXB:', product.publisher?.email ?? ''),
                      if (product.promotion != null && product.promotion!.isActive)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('Khuyến mãi:', style: TextStyle(fontWeight: FontWeight.bold)),
                            _buildInfoRow('Tên:', product.promotion?.name ?? ''),
                            _buildInfoRow('Phần trăm giảm:', '${product.promotion?.discount?.toStringAsFixed(0) ?? '0'}%'),
                            _buildInfoRow('Mô tả:', product.promotion?.description ?? ''),
                            _buildInfoRow('Thời gian:', _promotionTime(product.promotion)),
                          ],
                        ),
                      // Đẩy mô tả xuống cuối cùng
                      if ((product.description ?? '').isNotEmpty) ...[
                        SizedBox(height: 16),
                        Text('Mô tả:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(product.description ?? ''),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 80),
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
                                _updateQuantity(1);
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
                      onPressed: () async {
                        CartService.addToCart(product, _quantity);
                        final productId = product.productId ?? 0;
                        final tenSanPham = product.title ?? '';
                        final donGia = hasDiscount ? discountedPrice : product.price ?? 0;
                        final soLuong = _quantity;
                        final thanhTien = donGia * soLuong;
                        // Tạm hardcode thông tin khách hàng demo
                        final maKhachHang = 1;
                        final tenKhachHang = 'Demo User';
                        final diaChiGiaoHang = 'Demo Address';
                        final soDienThoai = '0123456789';
                        final tongTien = thanhTien;
                        final chiTietDonHang = [
                          {
                            'maSanPham': productId,
                            'tenSanPham': tenSanPham,
                            'soLuong': soLuong,
                            'donGia': donGia,
                            'thanhTien': thanhTien,
                          }
                        ];
                        final success = await OrderService.createOrder(
                          maKhachHang: maKhachHang,
                          tenKhachHang: tenKhachHang,
                          diaChiGiaoHang: diaChiGiaoHang,
                          soDienThoai: soDienThoai,
                          tongTien: tongTien,
                          chiTietDonHang: chiTietDonHang,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Đã thêm vào giỏ hàng!' : 'Thêm vào giỏ hàng thất bại!')),
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
                      onPressed: () async {
                        final productId = product.productId ?? 0;
                        final tenSanPham = product.title ?? '';
                        final donGia = hasDiscount ? discountedPrice : product.price ?? 0;
                        final soLuong = _quantity;
                        final thanhTien = donGia * soLuong;
                        // Tạm hardcode thông tin khách hàng demo
                        final maKhachHang = 1;
                        final tenKhachHang = 'Demo User';
                        final diaChiGiaoHang = 'Demo Address';
                        final soDienThoai = '0123456789';
                        final tongTien = thanhTien;
                        final chiTietDonHang = [
                          {
                            'maSanPham': productId,
                            'tenSanPham': tenSanPham,
                            'soLuong': soLuong,
                            'donGia': donGia,
                            'thanhTien': thanhTien,
                          }
                        ];
                        final success = await OrderService.createOrder(
                          maKhachHang: maKhachHang,
                          tenKhachHang: tenKhachHang,
                          diaChiGiaoHang: diaChiGiaoHang,
                          soDienThoai: soDienThoai,
                          tongTien: tongTien,
                          chiTietDonHang: chiTietDonHang,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Đặt hàng thành công!' : 'Đặt hàng thất bại!')),
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
      },
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

  String _formatCurrency(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.") + ' đ';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _promotionTime(Promotion? promo) {
    if (promo == null) return '';
    String start = promo.startDate != null ? _formatDate(promo.startDate!) : '';
    String end = promo.endDate != null ? _formatDate(promo.endDate!) : '';
    return start.isNotEmpty && end.isNotEmpty ? '$start - $end' : '';
  }
} 