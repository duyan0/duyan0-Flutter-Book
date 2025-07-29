import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';
import '../../../../services/order_service.dart';
import '../../../../services/user_session_service.dart';
import 'package:bookstore/features/auth/presentation/pages/login_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool _isLoading = false;
  String _errorMessage = '';
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = UserSessionService().currentUser;
      if (user != null) {
        print('👤 Đang lấy đơn hàng cho user: ${user.maKhachHang}, ${user.tenKhachHang}');
        
        final isAdmin = user.taiKhoan == 'admin' || user.email == 'admin@bookstore.com' || user.maKhachHang == 1;
        print('👑 User là admin: $isAdmin');
        
        final orders = isAdmin
            ? await OrderService.getAllOrders()
            : await OrderService.getOrdersByCustomerId(user.maKhachHang!);
        
        print('📦 Số lượng đơn hàng nhận được: ${orders.length}');
        
        // Debug thông tin đơn hàng
        if (orders.isNotEmpty) {
          print('🧾 THÔNG TIN TẤT CẢ ĐƠN HÀNG:');
          for (int i = 0; i < orders.length; i++) {
            final order = orders[i];
            print('📑 Đơn hàng #$i:');
            print('   - Mã đơn hàng: ${order.maDonHang}');
            print('   - Tên khách hàng: ${order.tenKhachHang}');
            print('   - Ngày đặt: ${order.ngayDatHang}');
            print('   - Tổng tiền: ${order.tongTien}');
            print('   - Trạng thái: ${order.trangThai}');
            print('   - Địa chỉ: ${order.diaChiGiaoHang}');
            
            // Debug chi tiết đơn hàng
            if (order.chiTietDonHang != null && order.chiTietDonHang!.isNotEmpty) {
              print('   - Chi tiết đơn hàng:');
              for (var detail in order.chiTietDonHang!) {
                print('     + ${detail.tenSanPham} (${detail.soLuong} x ${detail.donGia})');
              }
            }
          }
        } else {
          print('❌ Không tìm thấy đơn hàng nào');
        }
        
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('💥 Lỗi khi tải đơn hàng: $e');
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSessionService().currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bạn cần đăng nhập để xem lịch sử đơn hàng.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC92127),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('🔄 Tải lại danh sách đơn hàng');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang tải lại đơn hàng...')),
              );
              _loadOrders();
            },
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang tải đơn hàng...'),
                  ],
                ),
              )
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadOrders,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC92127),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : _orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Không tìm thấy đơn hàng nào',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mã khách hàng: ${user.maKhachHang}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                print('🔄 Tải lại danh sách đơn hàng');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đang tải lại đơn hàng...')),
                                );
                                _loadOrders();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tải lại'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC92127),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return _buildOrderCard(order);
                        },
                      ),
      ),
    );
  }
  
  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () {
          _showOrderDetails(order);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đơn hàng #${order.maDonHang ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.trangThai ?? ''),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.trangThai ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Ngày đặt: ${order.ngayDatHang != null ? DateFormat('dd/MM/yyyy HH:mm').format(order.ngayDatHang!) : 'Không rõ'}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Người nhận: ${order.tenKhachHang ?? ''}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Địa chỉ: ${order.diaChiGiaoHang ?? ''}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    order.tongTien != null ? NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(order.tongTien) : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFC92127),
                    ),
                  ),
                ],
              ),
              if (order.chiTietDonHang != null && order.chiTietDonHang!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${order.chiTietDonHang!.length} sản phẩm',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chi tiết đơn hàng #${order.maDonHang}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Trạng thái', order.trangThai ?? '', isStatus: true),
                    _buildInfoRow('Ngày đặt', order.ngayDatHang != null 
                        ? DateFormat('dd/MM/yyyy HH:mm').format(order.ngayDatHang!) 
                        : 'Không rõ'),
                    _buildInfoRow('Người nhận', order.tenKhachHang ?? ''),
                    _buildInfoRow('Địa chỉ', order.diaChiGiaoHang ?? ''),
                    _buildInfoRow('Số điện thoại', order.soDienThoai ?? ''),
                    if (order.ghiChu != null && order.ghiChu!.isNotEmpty)
                      _buildInfoRow('Ghi chú', order.ghiChu ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sản phẩm đã đặt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: order.chiTietDonHang != null && order.chiTietDonHang!.isNotEmpty
                    ? ListView.builder(
                        itemCount: order.chiTietDonHang!.length,
                        itemBuilder: (context, index) {
                          final detail = order.chiTietDonHang![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                detail.tenSanPham ?? 'Sản phẩm không xác định',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                '${detail.soLuong} x ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(detail.donGia)}',
                              ),
                              trailing: Text(
                                NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(detail.thanhTien),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFC92127),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Không có thông tin chi tiết sản phẩm'),
                      ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.tongTien != null
                          ? NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(order.tongTien)
                          : '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC92127),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
              );
            },
          );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(value),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Hàm lấy màu theo trạng thái đơn hàng
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'chờ xác nhận':
        return Colors.orange;
      case 'đã xác nhận':
        return Colors.blue;
      case 'đang giao hàng':
        return Colors.purple;
      case 'đã giao hàng':
        return Colors.green;
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 