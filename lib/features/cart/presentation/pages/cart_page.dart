import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Sample cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'image': 'lib/core/assets/8935235241848.jpeg',
      'title': 'Hành Trình Về Phương Đông',
      'price': '90.500',
      'quantity': 1,
      'selected': true,
    },
    {
      'image': 'lib/core/assets/2030xuhuonglon.jpg',
      'title': '25 Chuyên Đề Ngữ Pháp Tiếng Anh',
      'price': '86.500',
      'quantity': 2,
      'selected': true,
    },
    {
      'image': 'lib/core/assets/8935235237773.jpeg',
      'title': 'Giấy photo Double A',
      'price': '106.950',
      'quantity': 1,
      'selected': false,
    },
  ];

  bool _selectAll = true;

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in _cartItems) {
        item['selected'] = _selectAll;
      }
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      _cartItems[index]['selected'] = !_cartItems[index]['selected'];
      _selectAll = _cartItems.every((item) => item['selected']);
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQuantity = _cartItems[index]['quantity'] + delta;
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item['selected']) {
        total += double.parse(item['price'].replaceAll('.', '')) * item['quantity'];
      }
    }
    return total.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
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
              // Xử lý xóa tất cả
            },
            child: const Text(
              'Xóa tất cả',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                  value: _selectAll,
                  onChanged: (value) => _toggleSelectAll(),
                  activeColor: const Color(0xFFC92127),
                ),
                const Text(
                  'Chọn tất cả',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _cartItems.isEmpty
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
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Dismissible(
                        key: Key(item['title']),
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
                        onDismissed: (direction) => _removeItem(index),
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
                              Checkbox(
                                value: item['selected'],
                                onChanged: (value) => _toggleItemSelection(index),
                                activeColor: const Color(0xFFC92127),
                              ),
                              const SizedBox(width: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item['image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['price']} đ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFC92127),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => _updateQuantity(index, -1),
                                          icon: const Icon(Icons.remove_circle_outline),
                                          color: const Color(0xFFC92127),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${item['quantity']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () => _updateQuantity(index, 1),
                                          icon: const Icon(Icons.add_circle_outline),
                                          color: const Color(0xFFC92127),
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
                      '$_totalPrice đ',
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
                    onPressed: () {
                      // Xử lý thanh toán
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
    );
  }
} 