class OrderDetail {
  final String? id;
  final int? orderDetailId;
  final int? productId;
  final String? productName;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;

  OrderDetail({
    this.id,
    this.orderDetailId,
    this.productId,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing OrderDetail: ${json.keys.join(', ')}');
    return OrderDetail(
      id: json['\$id'],
      orderDetailId: json['maDonHangChiTiet'] ?? json['orderDetailId'],
      productId: json['maSanPham'] ?? json['productId'],
      productName: json['tenSanPham'] ?? json['productName'],
      quantity: json['soLuong'] ?? json['quantity'],
      unitPrice: json['donGia']?.toDouble() ?? json['unitPrice']?.toDouble(),
      totalPrice: json['thanhTien']?.toDouble() ?? json['totalPrice']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'maDonHangChiTiet': orderDetailId,
      'maSanPham': productId,
      'tenSanPham': productName,
      'soLuong': quantity,
      'donGia': unitPrice,
      'thanhTien': totalPrice,
    };
  }

  // Getter để tương thích với code cũ
  int? get maSanPham => productId;
  String? get tenSanPham => productName;
  int? get soLuong => quantity;
  double? get donGia => unitPrice;
  double? get thanhTien => totalPrice;
}

class Order {
  final String? id;
  final int? orderId;
  final int? customerId;
  final String? customerName;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final String? deliveryAddress;
  final String? phoneNumber;
  final String? notes;
  final double? totalAmount;
  final String? status;
  final List<OrderDetail>? orderDetails;

  Order({
    this.id,
    this.orderId,
    this.customerId,
    this.customerName,
    this.orderDate,
    this.deliveryDate,
    this.deliveryAddress,
    this.phoneNumber,
    this.notes,
    this.totalAmount,
    this.status,
    this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing Order from JSON: ${json.keys.join(', ')}');
    
    // Xác định các trường từ API thực tế
    final orderId = json['maDonHang'] ?? json['orderId'];
    final customerId = json['maKhachHang'] ?? json['customerId'];
    final customerName = json['tenKhachHang'] ?? json['customerName'];
    final orderDate = json['ngayDatHang'] ?? json['orderDate'];
    final deliveryDate = json['ngayGiaoHang'] ?? json['deliveryDate'];
    final deliveryAddress = json['diaChiGiaoHang'] ?? json['deliveryAddress'];
    final phoneNumber = json['soDienThoai'] ?? json['phoneNumber'];
    final notes = json['ghiChu'] ?? json['notes'];
    final totalAmount = json['tongTien'] ?? json['totalAmount'];
    final status = json['trangThai'] ?? json['status'];
    
    // Xử lý chi tiết đơn hàng
    List<OrderDetail>? details;
    
    if (json['chiTietDonHang'] != null) {
      if (json['chiTietDonHang'] is Map && json['chiTietDonHang']['\$values'] != null) {
        print('📦 Parsing chiTietDonHang with \$values structure');
        details = List<OrderDetail>.from(
          json['chiTietDonHang']['\$values'].map((x) => OrderDetail.fromJson(x))
        );
      } else if (json['chiTietDonHang'] is List) {
        print('📦 Parsing chiTietDonHang as List');
        details = List<OrderDetail>.from(
          json['chiTietDonHang'].map((x) => OrderDetail.fromJson(x))
        );
      }
    } else if (json['orderDetails'] != null) {
      print('📦 Parsing orderDetails');
      details = List<OrderDetail>.from(
        json['orderDetails'].map((x) => OrderDetail.fromJson(x))
      );
    }
    
    // Parse DateTime
    DateTime? parsedOrderDate;
    if (orderDate != null) {
      try {
        parsedOrderDate = DateTime.parse(orderDate.toString());
        print('📅 Parsed orderDate: $parsedOrderDate from $orderDate');
      } catch (e) {
        print('❌ Error parsing orderDate: $e');
      }
    }
    
    DateTime? parsedDeliveryDate;
    if (deliveryDate != null && deliveryDate.toString() != 'null') {
      try {
        parsedDeliveryDate = DateTime.parse(deliveryDate.toString());
      } catch (e) {
        print('❌ Error parsing deliveryDate: $e');
      }
    }
    
    // Tạo đối tượng Order
    final order = Order(
      id: json['\$id'],
      orderId: orderId,
      customerId: customerId,
      customerName: customerName,
      orderDate: parsedOrderDate,
      deliveryDate: parsedDeliveryDate,
      deliveryAddress: deliveryAddress,
      phoneNumber: phoneNumber,
      notes: notes,
      totalAmount: totalAmount?.toDouble(),
      status: status,
      orderDetails: details,
    );
    
    print('✅ Parsed Order: maDonHang=${order.maDonHang}, tenKhachHang=${order.tenKhachHang}, ngayDatHang=${order.ngayDatHang}');
    return order;
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'maDonHang': orderId,
      'maKhachHang': customerId,
      'tenKhachHang': customerName,
      'ngayDatHang': orderDate?.toIso8601String(),
      'ngayGiaoHang': deliveryDate?.toIso8601String(),
      'diaChiGiaoHang': deliveryAddress,
      'soDienThoai': phoneNumber,
      'ghiChu': notes,
      'tongTien': totalAmount,
      'trangThai': status,
      'chiTietDonHang': {
        '\$values': orderDetails?.map((x) => x.toJson()).toList()
      },
    };
  }

  // Getter để tương thích với code cũ
  int? get maDonHang => orderId;
  int? get maKhachHang => customerId;
  String? get tenKhachHang => customerName;
  DateTime? get ngayDatHang => orderDate;
  DateTime? get ngayGiaoHang => deliveryDate;
  String? get diaChiGiaoHang => deliveryAddress;
  String? get soDienThoai => phoneNumber;
  String? get ghiChu => notes;
  double? get tongTien => totalAmount;
  String? get trangThai => status;
  List<OrderDetail>? get donHangChiTiets => orderDetails;
  List<OrderDetail>? get chiTietDonHang => orderDetails;
} 