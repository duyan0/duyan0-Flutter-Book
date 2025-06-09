import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Tất cả';
  final List<String> _filters = ['Tất cả', 'Đơn hàng', 'Khuyến mãi', 'Hệ thống'];

  // Sample notifications
  List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Đơn hàng của bạn đã được xác nhận',
      'message': 'Đơn hàng #12345 đã được xác nhận và đang được xử lý',
      'time': '5 phút trước',
      'isRead': false,
      'type': 'Đơn hàng',
    },
    {
      'title': 'Khuyến mãi mới',
      'message': 'Giảm giá 50% cho tất cả sách tiếng Anh',
      'time': '1 giờ trước',
      'isRead': false,
      'type': 'Khuyến mãi',
    },
    {
      'title': 'Đơn hàng đã được giao',
      'message': 'Đơn hàng #12340 đã được giao thành công',
      'time': '2 giờ trước',
      'isRead': true,
      'type': 'Đơn hàng',
    },
    {
      'title': 'Cập nhật hệ thống',
      'message': 'Hệ thống sẽ được bảo trì vào ngày mai',
      'time': '1 ngày trước',
      'isRead': true,
      'type': 'Hệ thống',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedFilter = _filters[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa thông báo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'Tất cả') {
      return _notifications;
    }
    return _notifications.where((n) => n['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC92127),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Đánh dấu đã đọc',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _filters.map((filter) => Tab(text: filter)).toList(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Xử lý refresh thông báo
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            // Thêm logic refresh ở đây
          });
        },
        child: _filteredNotifications.isEmpty
            ? const Center(
                child: Text(
                  'Không có thông báo mới',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredNotifications.length,
                itemBuilder: (context, index) {
                  final notification = _filteredNotifications[index];
                  return Dismissible(
                    key: Key(notification['title']),
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
                      final originalIndex = _notifications.indexOf(notification);
                      _deleteNotification(originalIndex);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: notification['isRead']
                            ? Colors.grey[100]
                            : const Color(0xFF6BBA72).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification['title'],
                                  style: TextStyle(
                                    fontWeight: notification['isRead']
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                notification['time'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['message'],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 