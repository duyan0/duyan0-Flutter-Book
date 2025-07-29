import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookstore/models/order.dart';

class OrderService {
  static const String baseUrl = 'http://10.0.2.2:5070/api/donhang';

  // Tạo đơn hàng mới
  static Future<bool> createOrder({
    required int maKhachHang,
    required String tenKhachHang,
    required String diaChiGiaoHang,
    required String soDienThoai,
    required double tongTien,
    required List<Map<String, dynamic>> chiTietDonHang,
    String? ghiChu,
  }) async {
    try {
      print('🛒 Đang tạo đơn hàng cho khách hàng: $maKhachHang, $tenKhachHang');
      print('📦 Chi tiết đơn hàng: ${chiTietDonHang.length} sản phẩm, tổng tiền: $tongTien');
      
      final body = jsonEncode({
        'maKhachHang': maKhachHang,
        'tenKhachHang': tenKhachHang,
        'diaChiGiaoHang': diaChiGiaoHang,
        'soDienThoai': soDienThoai,
        'tongTien': tongTien,
        'ghiChu': ghiChu,
        'chiTietDonHang': chiTietDonHang,
      });
      
      print('📤 Gửi request đến: $baseUrl');
      print('📄 Body: $body');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Đặt hàng thành công!');
        return true;
      } else {
        print('❌ Đặt hàng thất bại! Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 Lỗi khi đặt hàng: $e');
      return false;
    }
  }

  // Lấy danh sách đơn hàng theo mã khách hàng
  static Future<List<Order>> getOrdersByCustomerId(int maKhachHang) async {
    try {
      print('🔍 Đang lấy đơn hàng của khách hàng: $maKhachHang');
      
      // Thử endpoint theo khách hàng trước
      final String endpoint = 'http://10.0.2.2:5070/api/donhang/khachhang/$maKhachHang';
      print('🔗 Endpoint khách hàng: $endpoint');
      
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('✅ API trả về thành công');
        final data = json.decode(response.body);
        
        // Xử lý dữ liệu trả về
        return _parseOrdersResponse(data, maKhachHang);
      } else {
        print('❌ API trả về lỗi: ${response.statusCode}');
        
        // Thử phương pháp lấy tất cả đơn hàng và lọc
        print('🔄 Thử phương pháp lấy tất cả đơn hàng và lọc');
        return await getAllOrdersAndFilter(maKhachHang);
      }
    } catch (e) {
      print('💥 Lỗi khi lấy đơn hàng theo khách hàng: $e');
      
      // Thử phương pháp lấy tất cả đơn hàng và lọc
      print('🔄 Thử phương pháp lấy tất cả đơn hàng và lọc sau khi gặp lỗi');
      return await getAllOrdersAndFilter(maKhachHang);
    }
  }

  // Lấy tất cả đơn hàng và lọc theo khách hàng
  static Future<List<Order>> getAllOrdersAndFilter(int maKhachHang) async {
    try {
      print('🔍 Lấy tất cả đơn hàng và lọc theo khách hàng: $maKhachHang');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Parsed all orders data structure: ${data.runtimeType}');
        
        List<Order> allOrders = [];
        
        // Xử lý cấu trúc response theo apidonhang.txt
        if (data['success'] == true && data['data'] != null) {
          print('✅ API trả về thành công, kiểm tra cấu trúc data');
          
          // Cấu trúc theo apidonhang.txt
          if (data['data'] is Map && data['data']['items'] != null && 
              data['data']['items']['\$values'] != null) {
            print('📋 Data có cấu trúc items.\$values, xử lý...');
            final List ordersJson = data['data']['items']['\$values'] as List;
            allOrders = ordersJson.map((json) => Order.fromJson(json)).toList();
            print('📋 Đã parse được ${allOrders.length} đơn hàng từ items.\$values');
          }
          // Cấu trúc khác
          else if (data['data'] is List) {
            print('📋 Data là List, số lượng: ${data['data'].length}');
            final List ordersJson = data['data'] as List;
            allOrders = ordersJson.map((json) => Order.fromJson(json)).toList();
          } 
          else if (data['data'] is Map && data['data']['\$values'] != null) {
            print('📋 Data có cấu trúc \$values, số lượng: ${data['data']['\$values'].length}');
            final List ordersJson = data['data']['\$values'] as List;
            allOrders = ordersJson.map((json) => Order.fromJson(json)).toList();
          }
          else if (data['data'] is Map) {
            print('📋 Data là một đơn hàng đơn lẻ');
            final order = Order.fromJson(data['data']);
            allOrders = [order];
          }
        }
        
        // Lọc theo khách hàng
        final filteredOrders = allOrders.where((order) => order.maKhachHang == maKhachHang).toList();
        print('📋 Tìm thấy ${filteredOrders.length} đơn hàng của khách hàng $maKhachHang');
        
        // In thông tin đơn hàng để debug
        for (int i = 0; i < filteredOrders.length; i++) {
          final order = filteredOrders[i];
          print('🧾 Đơn hàng #$i - ID: ${order.maDonHang}, Khách hàng: ${order.tenKhachHang}');
        }
        
        return filteredOrders;
      } else {
        print('❌ Lấy tất cả đơn hàng thất bại! Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('💥 Lỗi khi lấy tất cả đơn hàng: $e');
      return [];
    }
  }

  // Lấy tất cả đơn hàng (cho admin)
  static Future<List<Order>> getAllOrders() async {
    try {
      print('🔍 Đang lấy tất cả đơn hàng');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseOrdersResponse(data, null);
      } else {
        print('❌ Lấy đơn hàng thất bại! Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('💥 Lỗi khi lấy đơn hàng: $e');
      return [];
    }
  }
  
  // Hàm xử lý chung cho response từ API
  static List<Order> _parseOrdersResponse(dynamic data, int? filterByCustomerId) {
    print('📦 Parsing orders response: ${data.runtimeType}');
    List<Order> orders = [];
    
    try {
      // Kiểm tra cấu trúc response
      if (data['success'] == true && data['data'] != null) {
        print('✅ API trả về thành công, kiểm tra cấu trúc data');
        
        // Cấu trúc theo apidonhang.txt
        if (data['data'] is Map && data['data']['items'] != null && 
            data['data']['items']['\$values'] != null) {
          print('📋 Data có cấu trúc items.\$values, xử lý...');
          final List ordersJson = data['data']['items']['\$values'] as List;
          orders = ordersJson.map((json) => Order.fromJson(json)).toList();
          print('📋 Đã parse được ${orders.length} đơn hàng từ items.\$values');
        }
        // Cấu trúc khác
        else if (data['data'] is List) {
          print('📋 Data là List, số lượng: ${data['data'].length}');
          final List ordersJson = data['data'] as List;
          orders = ordersJson.map((json) => Order.fromJson(json)).toList();
        } 
        else if (data['data'] is Map && data['data']['\$values'] != null) {
          print('📋 Data có cấu trúc \$values, số lượng: ${data['data']['\$values'].length}');
          final List ordersJson = data['data']['\$values'] as List;
          orders = ordersJson.map((json) => Order.fromJson(json)).toList();
        }
        else if (data['data'] is Map) {
          print('📋 Data là một đơn hàng đơn lẻ');
          final order = Order.fromJson(data['data']);
          orders = [order];
        }
      }
      
      // Lọc theo khách hàng nếu cần
      if (filterByCustomerId != null) {
        orders = orders.where((order) => order.maKhachHang == filterByCustomerId).toList();
        print('🔍 Đã lọc: ${orders.length} đơn hàng của khách hàng $filterByCustomerId');
      }
      
      print('📋 Số lượng đơn hàng tìm thấy: ${orders.length}');
      if (orders.isNotEmpty) {
        print('🧾 Mẫu đơn hàng đầu tiên: ${orders.first.maDonHang}');
      }
    } catch (e) {
      print('💥 Lỗi khi parse orders response: $e');
    }
    
    return orders;
  }
} 