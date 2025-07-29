import 'package:flutter/material.dart';
import 'package:bookstore/services/cart_service.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/services/order_service.dart';
import 'package:bookstore/services/user_session_service.dart';
import 'package:bookstore/models/khach_hang.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String get _totalPrice {
    double total = 0;
    for (var item in CartService.getCartItems()) {
      final price = item.product.price ?? 0;
      final discount = (item.product.promotion != null && item.product.promotion!.discount != null && item.product.promotion!.discount! > 0)
          ? item.product.promotion!.discount!
          : 0;
      final priceAfterDiscount = price * (1 - discount / 100);
      total += priceAfterDiscount * item.quantity;
    }
    return total.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _formatCurrency(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => "${m[1]}.",
    ) + ' đ';
  }

  // Thêm biến để theo dõi trạng thái loading
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = CartService.getCartItems();
    // Thêm danh sách lưu trạng thái chọn của từng sản phẩm
    List<bool> selected = List.generate(cartItems.length, (index) => false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC92127),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                CartService.clearCart();
              });
            },
            child: const Text(
              'Xóa tất cả',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    // Bỏ chọn tất cả nếu muốn đơn giản hóa
                    const Text(
                      'Sản phẩm trong giỏ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          'Giỏ hàng trống',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          final product = cartItem.product;
                          return Dismissible(
                            key: Key(product.productId.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                CartService.getCartItems().removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: product.image != null && product.image!.isNotEmpty
                                        ? Image.network(
                                            product.image!.startsWith('http') ? product.image! : 'http://10.0.2.2:5070/${product.image!}',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.book, size: 40, color: Colors.grey),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Builder(
                                          builder: (context) {
                                            final price = product.price ?? 0;
                                            final discount = (product.promotion != null && product.promotion!.discount != null && product.promotion!.discount! > 0)
                                                ? product.promotion!.discount!
                                                : 0;
                                            final priceAfterDiscount = price * (1 - discount / 100);
                                            return Row(
                                              children: [
                                                Text(
                                                  _formatCurrency(priceAfterDiscount),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFC92127),
                                                  ),
                                                ),
                                                if (discount > 0) ...[
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _formatCurrency(price),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      '-${discount.toInt()}%',
                                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (cartItem.quantity > 1) cartItem.quantity--;
                                                });
                                              },
                                              icon: const Icon(Icons.remove_circle_outline),
                                              color: const Color(0xFFC92127),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${cartItem.quantity}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  cartItem.quantity++;
                                                });
                                              },
                                              icon: const Icon(Icons.add_circle_outline),
                                              color: const Color(0xFFC92127),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                            // Nút xóa cạnh sản phẩm
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  CartService.removeAt(index);
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng tiền:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatCurrency(double.tryParse(_totalPrice.replaceAll('.', ''))),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC92127),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          // Xử lý thanh toán
                          final user = UserSessionService().currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bạn cần đăng nhập để thanh toán!')),
                            );
                            return;
                          }
                          final cartItems = CartService.getCartItems();
                          if (cartItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Giỏ hàng trống!')),
                            );
                            return;
                          }
                          
                          try {
                            // Bật trạng thái loading
                            setState(() {
                              _isLoading = true;
                            });
                            
                            // Kiểm tra địa chỉ giao hàng
                            final diaChiGiaoHang = user.diaChi?.trim() ?? '';
                            if (diaChiGiaoHang.isEmpty) {
                              setState(() {
                                _isLoading = false;
                              });
                              _showDiaChiDialog(context, user);
                              return;
                            }
                            
                            final chiTietDonHang = cartItems.map((item) => {
                              'maSanPham': item.product.productId,
                              'soLuong': item.quantity,
                              'donGia': item.product.price,
                              'giamGia': item.product.promotion?.discount ?? 0,
                            }).toList();
                            
                            print('🛒 Đang chuẩn bị thanh toán:');
                            print('👤 User ID: ${user.maKhachHang}');
                            print('📦 Số lượng sản phẩm: ${cartItems.length}');
                            print('📝 Chi tiết: $chiTietDonHang');
                            
                            final tongTien = cartItems.fold<double>(0, (sum, item) {
                              final price = item.product.price ?? 0;
                              final discount = (item.product.promotion?.discount ?? 0);
                              final priceAfterDiscount = price * (1 - discount / 100);
                              return sum + priceAfterDiscount * item.quantity;
                            });
                            
                            print('💰 Tổng tiền: $tongTien');
                            
                            final success = await OrderService.createOrder(
                              maKhachHang: user.maKhachHang!,
                              tenKhachHang: user.tenKhachHang ?? '',
                              diaChiGiaoHang: diaChiGiaoHang,
                              soDienThoai: user.soDienThoai ?? '',
                              tongTien: tongTien,
                              chiTietDonHang: chiTietDonHang,
                            );
                            
                            // Tắt trạng thái loading
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                              
                              if (success) {
                                setState(() {
                                  CartService.clearCart();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đặt hàng thành công!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đặt hàng thất bại! Vui lòng kiểm tra kết nối và thử lại.'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            print('💥 Lỗi thanh toán: $e');
                            
                            // Tắt trạng thái loading
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lỗi: $e'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC92127),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Thanh toán',
                          style: TextStyle(
                            fontSize: 16,
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
          // Hiển thị loading overlay khi đang xử lý
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC92127)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Hiển thị dialog yêu cầu nhập địa chỉ giao hàng
  void _showDiaChiDialog(BuildContext context, KhachHang user) {
    final TextEditingController diaChiController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cần địa chỉ giao hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vui lòng nhập địa chỉ giao hàng để tiếp tục'),
              const SizedBox(height: 16),
              TextField(
                controller: diaChiController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ giao hàng',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC92127),
              ),
              onPressed: () async {
                final diaChi = diaChiController.text.trim();
                if (diaChi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng')),
                  );
                  return;
                }
                
                // Cập nhật địa chỉ cho user và tiếp tục đặt hàng
                user.diaChi = diaChi;
                Navigator.of(context).pop();
                
                // Gọi lại hàm thanh toán
                setState(() {});
              },
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
} 