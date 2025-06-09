import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  String _selectedStatus = 'Tất cả';
  final List<String> _statuses = ['Tất cả', 'Chờ xác nhận', 'Đang xử lý', 'Đang giao hàng', 'Hoàn thành', 'Đã hủy'];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD001',
      'customer': 'Nguyễn Văn A',
      'date': '2024-03-15',
      'total': '450.000',
      'status': 'Chờ xác nhận',
      'items': [
        {'name': 'Hành Trình Về Phương Đông', 'quantity': 2, 'price': '90.500'},
        {'name': '25 Chuyên Đề Ngữ Pháp', 'quantity': 3, 'price': '86.500'},
      ],
    },
    {
      'id': 'ORD002',
      'customer': 'Trần Thị B',
      'date': '2024-03-14',
      'total': '180.000',
      'status': 'Đang giao hàng',
      'items': [
        {'name': 'Cân Bằng Cảm Xúc', 'quantity': 1, 'price': '99.000'},
        {'name': 'Thiết Kế Cuộc Đời', 'quantity': 1, 'price': '85.000'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC92127),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm đơn hàng...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    underline: const SizedBox(),
                    items: _statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    leading: const Icon(Icons.shopping_bag, color: Color(0xFFC92127)),
                    title: Text(
                      'Đơn hàng ${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Khách hàng: ${order['customer']}\nNgày đặt: ${order['date']}\nTổng tiền: ${order['total']} đ',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order['status'],
                        style: TextStyle(
                          color: _getStatusColor(order['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chi tiết đơn hàng:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...order['items'].map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item['name']} x${item['quantity']}',
                                      ),
                                    ),
                                    Text(
                                      '${item['price']} đ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Implement view details
                                  },
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('Chi tiết'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Implement update status
                                  },
                                  icon: const Icon(Icons.update),
                                  label: const Text('Cập nhật'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Implement cancel order
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Hủy'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đang xử lý':
        return Colors.blue;
      case 'Đang giao hàng':
        return Colors.purple;
      case 'Hoàn thành':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 