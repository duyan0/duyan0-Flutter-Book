import 'package:flutter/material.dart';

class PromotionManagement extends StatefulWidget {
  const PromotionManagement({super.key});

  @override
  State<PromotionManagement> createState() => _PromotionManagementState();
}

class _PromotionManagementState extends State<PromotionManagement> {
  final List<Map<String, dynamic>> _promotions = [
    {
      'id': '1',
      'code': 'SUMMER2024',
      'description': 'Giảm giá mùa hè 2024',
      'discount': 20,
      'type': 'percentage',
      'startDate': '2024-06-01',
      'endDate': '2024-08-31',
      'status': 'active',
    },
    {
      'id': '2',
      'code': 'WELCOME50K',
      'description': 'Giảm 50k cho khách hàng mới',
      'discount': 50000,
      'type': 'fixed',
      'startDate': '2024-01-01',
      'endDate': '2024-12-31',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý khuyến mãi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFC92127),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add promotion
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm mã khuyến mãi...',
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
                    value: 'Tất cả',
                    underline: const SizedBox(),
                    items: ['Tất cả', 'Đang hoạt động', 'Đã hết hạn']
                        .map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // TODO: Implement filter
                    },
                  ),
                ),
              ],
            ),
          ),

          // Promotions list
          Expanded(
            child: ListView.builder(
              itemCount: _promotions.length,
              itemBuilder: (context, index) {
                final promotion = _promotions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: promotion['status'] == 'active'
                          ? Colors.green
                          : Colors.grey,
                      child: const Icon(Icons.local_offer, color: Colors.white),
                    ),
                    title: Text(
                      promotion['code'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(promotion['description']),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              'Loại giảm giá:',
                              promotion['type'] == 'percentage'
                                  ? '${promotion['discount']}%'
                                  : '${promotion['discount']} đ',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Thời gian:',
                              '${promotion['startDate']} - ${promotion['endDate']}',
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Chỉnh sửa'),
                                  onPressed: () {
                                    // TODO: Implement edit
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Xóa'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    // TODO: Implement delete
                                  },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC92127),
        onPressed: () {
          // TODO: Implement add promotion
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
} 