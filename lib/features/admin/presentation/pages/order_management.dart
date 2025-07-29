import 'package:flutter/material.dart';
import 'package:bookstore/models/order.dart';
import 'package:bookstore/services/order_service.dart';
import 'package:bookstore/services/auth_service.dart';
import 'package:intl/intl.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({Key? key}) : super(key: key);

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orders = await OrderService.getAllOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    try {
      await OrderService.updateOrderStatus(order.orderId!, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái thành công')),
      );
      _loadOrders(); // Reload orders
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết đơn hàng #${order.orderId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Khách hàng: ${order.customerName}'),
              Text('Số điện thoại: ${order.phoneNumber}'),
              Text('Địa chỉ: ${order.deliveryAddress}'),
              Text('Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate!)}'),
              Text('Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(order.totalAmount)}'),
              Text('Trạng thái: ${order.status}'),
              if (order.notes?.isNotEmpty == true) Text('Ghi chú: ${order.notes}'),
              const SizedBox(height: 16),
              const Text('Chi tiết sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...(order.orderDetails ?? []).map((detail) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('• Sản phẩm ID: ${detail.productId}, Số lượng: ${detail.quantity}, Đơn giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(detail.unitPrice)}'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi: $_error'),
                      ElevatedButton(
                        onPressed: _loadOrders,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _orders.isEmpty
                  ? const Center(child: Text('Không có đơn hàng nào'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text('Đơn hàng #${order.orderId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Khách hàng: ${order.customerName}'),
                                Text('Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.orderDate!)}'),
                                Text('Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(order.totalAmount)}'),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order.status ?? 'Chưa xác định',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _updateOrderStatus(order, value),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Chờ xác nhận',
                                  child: Text('Chờ xác nhận'),
                                ),
                                const PopupMenuItem(
                                  value: 'Đã xác nhận',
                                  child: Text('Đã xác nhận'),
                                ),
                                const PopupMenuItem(
                                  value: 'Đang giao',
                                  child: Text('Đang giao'),
                                ),
                                const PopupMenuItem(
                                  value: 'Đã giao',
                                  child: Text('Đã giao'),
                                ),
                                const PopupMenuItem(
                                  value: 'Đã hủy',
                                  child: Text('Đã hủy'),
                                ),
                              ],
                              child: const Icon(Icons.more_vert),
                            ),
                            onTap: () => _showOrderDetails(order),
                          ),
                        );
                      },
                    ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đã xác nhận':
        return Colors.blue;
      case 'Đang giao':
        return Colors.purple;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 