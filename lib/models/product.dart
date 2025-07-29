class Category {
  final String? id;
  final int? categoryId;
  final String? name;

  Category({
    this.id,
    this.categoryId,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['\$id'],
      categoryId: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'id': categoryId,
      'name': name,
    };
  }
}

class Author {
  final String? id;
  final int? authorId;
  final String? name;
  final DateTime? birthday;
  final String? country;
  final String? bio;
  final String? image;

  Author({
    this.id,
    this.authorId,
    this.name,
    this.birthday,
    this.country,
    this.bio,
    this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['\$id'],
      authorId: json['id'],
      name: json['name'],
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null,
      country: json['country'],
      bio: json['bio'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'id': authorId,
      'name': name,
      'birthday': birthday?.toIso8601String(),
      'country': country,
      'bio': bio,
      'image': image,
    };
  }
}

class Publisher {
  final String? id;
  final int? publisherId;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;

  Publisher({
    this.id,
    this.publisherId,
    this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['\$id'],
      publisherId: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'id': publisherId,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

class Promotion {
  final String? id;
  final int? promotionId;
  final String? name;
  final double? discount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;

  Promotion({
    this.id,
    this.promotionId,
    this.name,
    this.discount,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['\$id'],
      promotionId: json['id'],
      name: json['name'],
      discount: json['discount']?.toDouble(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'id': promotionId,
      'name': name,
      'discount': discount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }

  // Kiểm tra khuyến mãi có hiệu lực không
  bool get isActive {
    if (discount == null || discount! <= 0) return false;
    
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    
    return true;
  }
}

class Product {
  final String? id;
  final int? productId;
  final String? title;
  final String? description;
  final double? price;
  final String? image;
  final int? quantity;
  final String? status;
  final DateTime? publicationDate;
  final String? isbn;
  final int? pageCount;
  final String? language;
  final Category? category;
  final Author? author;
  final Publisher? publisher;
  final Promotion? promotion;

  Product({
    this.id,
    this.productId,
    this.title,
    this.description,
    this.price,
    this.image,
    this.quantity,
    this.status,
    this.publicationDate,
    this.isbn,
    this.pageCount,
    this.language,
    this.category,
    this.author,
    this.publisher,
    this.promotion,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['\$id'],
      productId: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      status: json['status'],
      publicationDate: json['publicationDate'] != null ? DateTime.tryParse(json['publicationDate']) : null,
      isbn: json['isbn'],
      pageCount: json['pageCount'],
      language: json['language'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      publisher: json['publisher'] != null ? Publisher.fromJson(json['publisher']) : null,
      promotion: json['promotion'] != null ? Promotion.fromJson(json['promotion']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'id': productId,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'quantity': quantity,
      'status': status,
      'publicationDate': publicationDate?.toIso8601String(),
      'isbn': isbn,
      'pageCount': pageCount,
      'language': language,
      'category': category?.toJson(),
      'author': author?.toJson(),
      'publisher': publisher?.toJson(),
      'promotion': promotion?.toJson(),
    };
  }

  // Getter để tương thích với code cũ
  String? get tenSanPham => title;
  String? get moTa => description;
  double? get giaBan => price;
  double? get giaSauGiam {
    if (promotion?.isActive == true && promotion?.discount != null && price != null) {
      final discounted = price! * (1 - promotion!.discount! / 100);
      print('💰 Product: $title - Original: $price, Discount: ${promotion!.discount}%, After: $discounted');
      return discounted;
    }
    print('💰 Product: $title - No discount applied, price: $price');
    return price;
  }
  String? get hinhAnh => image;
  String? get danhMuc => category?.name;
  int? get soLuong => quantity;
  String? get trangThai => status;
  int? get sanPhamId => productId;

  // Tính phần trăm giảm giá
  double? get phanTramGiamGia {
    if (promotion?.isActive == true && promotion?.discount != null) {
      print('📊 Product: $title - Discount percentage: ${promotion!.discount}%');
      return promotion!.discount;
    }
    print('📊 Product: $title - No discount percentage');
    return null;
  }

  // Kiểm tra có giảm giá không
  bool get coGiamGia {
    final result = promotion?.isActive == true && promotion?.discount != null && promotion!.discount! > 0;
    print('🔍 Product: $title - Has discount: $result (${promotion?.discount}%)');
    return result;
  }

  // Kiểm tra còn hàng không
  bool get conHang => quantity != null && quantity! > 0 && status == 'Còn hàng';

  // Xử lý URL ảnh
  String? get hinhAnhUrl {
    if (image == null || image!.isEmpty) return null;
    
    // Nếu URL đã có http/https thì thay localhost thành 10.0.2.2 cho emulator
    if (image!.startsWith('http://') || image!.startsWith('https://')) {
      return image!.replaceAll('localhost', '10.0.2.2');
    }
    
    // Nếu URL bắt đầu bằng / thì thêm domain
    if (image!.startsWith('/')) {
      return 'http://10.0.2.2:5070$image';
    }
    
    // Nếu không có / ở đầu thì thêm domain và /
    return 'http://10.0.2.2:5070/$image';
  }
}
