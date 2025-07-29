import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product from JSON with nested objects', () {
      final json = {
        '\$id': 'test-id',
        'id': 1,
        'title': 'Test Book',
        'description': 'Test Description',
        'price': 100000.0,
        'image': '/images/test.jpg',
        'quantity': 10,
        'status': 'Còn hàng',
        'publicationDate': '2024-01-01T00:00:00Z',
        'isbn': '1234567890123',
        'pageCount': 200,
        'language': 'Tiếng Việt',
        'category': {
          '\$id': 'cat-id',
          'id': 1,
          'name': 'Văn học',
        },
        'author': {
          '\$id': 'author-id',
          'id': 1,
          'name': 'Test Author',
          'birthday': '1990-01-01T00:00:00Z',
          'country': 'Việt Nam',
          'bio': 'Test bio',
          'image': '/images/author.jpg',
        },
        'publisher': {
          '\$id': 'pub-id',
          'id': 1,
          'name': 'Test Publisher',
          'address': 'Test Address',
          'phone': '0123456789',
          'email': 'test@publisher.com',
        },
        'promotion': {
          '\$id': 'promo-id',
          'id': 1,
          'name': 'Test Promotion',
          'discount': 10.0,
          'startDate': '2024-01-01T00:00:00Z',
          'endDate': '2024-12-31T23:59:59Z',
          'description': 'Test promotion description',
        },
      };

      final product = Product.fromJson(json);

      expect(product.id, 'test-id');
      expect(product.productId, 1);
      expect(product.title, 'Test Book');
      expect(product.description, 'Test Description');
      expect(product.price, 100000.0);
      expect(product.image, '/images/test.jpg');
      expect(product.quantity, 10);
      expect(product.status, 'Còn hàng');
      expect(product.isbn, '1234567890123');
      expect(product.pageCount, 200);
      expect(product.language, 'Tiếng Việt');

      // Test nested objects
      expect(product.category?.id, 'cat-id');
      expect(product.category?.categoryId, 1);
      expect(product.category?.name, 'Văn học');

      expect(product.author?.id, 'author-id');
      expect(product.author?.authorId, 1);
      expect(product.author?.name, 'Test Author');
      expect(product.author?.country, 'Việt Nam');
      expect(product.author?.bio, 'Test bio');

      expect(product.publisher?.id, 'pub-id');
      expect(product.publisher?.publisherId, 1);
      expect(product.publisher?.name, 'Test Publisher');
      expect(product.publisher?.address, 'Test Address');
      expect(product.publisher?.phone, '0123456789');
      expect(product.publisher?.email, 'test@publisher.com');

      expect(product.promotion?.id, 'promo-id');
      expect(product.promotion?.promotionId, 1);
      expect(product.promotion?.name, 'Test Promotion');
      expect(product.promotion?.discount, 10.0);
      expect(product.promotion?.description, 'Test promotion description');
    });

    test('should create Product from JSON without nested objects', () {
      final json = {
        '\$id': 'test-id',
        'id': 1,
        'title': 'Test Book',
        'description': 'Test Description',
        'price': 100000.0,
        'image': '/images/test.jpg',
        'quantity': 10,
        'status': 'Còn hàng',
      };

      final product = Product.fromJson(json);

      expect(product.id, 'test-id');
      expect(product.productId, 1);
      expect(product.title, 'Test Book');
      expect(product.description, 'Test Description');
      expect(product.price, 100000.0);
      expect(product.image, '/images/test.jpg');
      expect(product.quantity, 10);
      expect(product.status, 'Còn hàng');

      // Nested objects should be null
      expect(product.category, null);
      expect(product.author, null);
      expect(product.publisher, null);
      expect(product.promotion, null);
    });

    test('should convert Product to JSON', () {
      final product = Product(
        id: 'test-id',
        productId: 1,
        title: 'Test Book',
        description: 'Test Description',
        price: 100000.0,
        image: '/images/test.jpg',
        quantity: 10,
        status: 'Còn hàng',
        category: Category(
          id: 'cat-id',
          categoryId: 1,
          name: 'Văn học',
        ),
        author: Author(
          id: 'author-id',
          authorId: 1,
          name: 'Test Author',
          country: 'Việt Nam',
        ),
        publisher: Publisher(
          id: 'pub-id',
          publisherId: 1,
          name: 'Test Publisher',
          address: 'Test Address',
        ),
        promotion: Promotion(
          id: 'promo-id',
          promotionId: 1,
          name: 'Test Promotion',
          discount: 10.0,
        ),
      );

      final json = product.toJson();

      expect(json['\$id'], 'test-id');
      expect(json['id'], 1);
      expect(json['title'], 'Test Book');
      expect(json['description'], 'Test Description');
      expect(json['price'], 100000.0);
      expect(json['image'], '/images/test.jpg');
      expect(json['quantity'], 10);
      expect(json['status'], 'Còn hàng');

      // Test nested objects
      expect(json['category']['\$id'], 'cat-id');
      expect(json['category']['id'], 1);
      expect(json['category']['name'], 'Văn học');

      expect(json['author']['\$id'], 'author-id');
      expect(json['author']['id'], 1);
      expect(json['author']['name'], 'Test Author');
      expect(json['author']['country'], 'Việt Nam');

      expect(json['publisher']['\$id'], 'pub-id');
      expect(json['publisher']['id'], 1);
      expect(json['publisher']['name'], 'Test Publisher');
      expect(json['publisher']['address'], 'Test Address');

      expect(json['promotion']['\$id'], 'promo-id');
      expect(json['promotion']['id'], 1);
      expect(json['promotion']['name'], 'Test Promotion');
      expect(json['promotion']['discount'], 10.0);
    });

    test('should calculate discounted price correctly', () {
      final product = Product(
        price: 100000.0,
        promotion: Promotion(
          discount: 20.0,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
        ),
      );

      expect(product.giaSauGiam, 80000.0); // 100000 * (1 - 20/100)
      expect(product.phanTramGiamGia, 20.0);
      expect(product.coGiamGia, true);
    });

    test('should not apply discount when promotion is not active', () {
      final product = Product(
        price: 100000.0,
        promotion: Promotion(
          discount: 20.0,
          startDate: DateTime(2025, 1, 1), // Future date
          endDate: DateTime(2025, 12, 31),
        ),
      );

      expect(product.giaSauGiam, 100000.0); // No discount applied
      expect(product.coGiamGia, false);
    });

    test('should check stock availability correctly', () {
      final inStockProduct = Product(
        quantity: 10,
        status: 'Còn hàng',
      );

      final outOfStockProduct = Product(
        quantity: 0,
        status: 'Hết hàng',
      );

      expect(inStockProduct.conHang, true);
      expect(outOfStockProduct.conHang, false);
    });

    test('should generate correct image URL', () {
      final product = Product(image: '/images/test.jpg');

      expect(product.hinhAnhUrl, 'http://10.0.2.2:5070/images/test.jpg');
    });

    test('should handle legacy getters correctly', () {
      final product = Product(
        productId: 1,
        title: 'Test Book',
        description: 'Test Description',
        price: 100000.0,
        image: '/images/test.jpg',
        quantity: 10,
        status: 'Còn hàng',
      );

      expect(product.sanPhamId, 1);
      expect(product.tenSanPham, 'Test Book');
      expect(product.moTa, 'Test Description');
      expect(product.giaBan, 100000.0);
      expect(product.hinhAnh, '/images/test.jpg');
      expect(product.soLuong, 10);
      expect(product.trangThai, 'Còn hàng');
    });
  });

  group('Category Model Tests', () {
    test('should create Category from JSON', () {
      final json = {
        '\$id': 'cat-id',
        'id': 1,
        'name': 'Văn học',
      };

      final category = Category.fromJson(json);

      expect(category.id, 'cat-id');
      expect(category.categoryId, 1);
      expect(category.name, 'Văn học');
    });

    test('should convert Category to JSON', () {
      final category = Category(
        id: 'cat-id',
        categoryId: 1,
        name: 'Văn học',
      );

      final json = category.toJson();

      expect(json['\$id'], 'cat-id');
      expect(json['id'], 1);
      expect(json['name'], 'Văn học');
    });
  });

  group('Author Model Tests', () {
    test('should create Author from JSON', () {
      final json = {
        '\$id': 'author-id',
        'id': 1,
        'name': 'Test Author',
        'birthday': '1990-01-01T00:00:00Z',
        'country': 'Việt Nam',
        'bio': 'Test bio',
        'image': '/images/author.jpg',
      };

      final author = Author.fromJson(json);

      expect(author.id, 'author-id');
      expect(author.authorId, 1);
      expect(author.name, 'Test Author');
      expect(author.country, 'Việt Nam');
      expect(author.bio, 'Test bio');
      expect(author.image, '/images/author.jpg');
    });

    test('should convert Author to JSON', () {
      final author = Author(
        id: 'author-id',
        authorId: 1,
        name: 'Test Author',
        country: 'Việt Nam',
        bio: 'Test bio',
      );

      final json = author.toJson();

      expect(json['\$id'], 'author-id');
      expect(json['id'], 1);
      expect(json['name'], 'Test Author');
      expect(json['country'], 'Việt Nam');
      expect(json['bio'], 'Test bio');
    });
  });

  group('Publisher Model Tests', () {
    test('should create Publisher from JSON', () {
      final json = {
        '\$id': 'pub-id',
        'id': 1,
        'name': 'Test Publisher',
        'address': 'Test Address',
        'phone': '0123456789',
        'email': 'test@publisher.com',
      };

      final publisher = Publisher.fromJson(json);

      expect(publisher.id, 'pub-id');
      expect(publisher.publisherId, 1);
      expect(publisher.name, 'Test Publisher');
      expect(publisher.address, 'Test Address');
      expect(publisher.phone, '0123456789');
      expect(publisher.email, 'test@publisher.com');
    });

    test('should convert Publisher to JSON', () {
      final publisher = Publisher(
        id: 'pub-id',
        publisherId: 1,
        name: 'Test Publisher',
        address: 'Test Address',
        phone: '0123456789',
        email: 'test@publisher.com',
      );

      final json = publisher.toJson();

      expect(json['\$id'], 'pub-id');
      expect(json['id'], 1);
      expect(json['name'], 'Test Publisher');
      expect(json['address'], 'Test Address');
      expect(json['phone'], '0123456789');
      expect(json['email'], 'test@publisher.com');
    });
  });

  group('Promotion Model Tests', () {
    test('should create Promotion from JSON', () {
      final json = {
        '\$id': 'promo-id',
        'id': 1,
        'name': 'Test Promotion',
        'discount': 10.0,
        'startDate': '2024-01-01T00:00:00Z',
        'endDate': '2024-12-31T23:59:59Z',
        'description': 'Test promotion description',
      };

      final promotion = Promotion.fromJson(json);

      expect(promotion.id, 'promo-id');
      expect(promotion.promotionId, 1);
      expect(promotion.name, 'Test Promotion');
      expect(promotion.discount, 10.0);
      expect(promotion.description, 'Test promotion description');
    });

    test('should convert Promotion to JSON', () {
      final promotion = Promotion(
        id: 'promo-id',
        promotionId: 1,
        name: 'Test Promotion',
        discount: 10.0,
        description: 'Test promotion description',
      );

      final json = promotion.toJson();

      expect(json['\$id'], 'promo-id');
      expect(json['id'], 1);
      expect(json['name'], 'Test Promotion');
      expect(json['discount'], 10.0);
      expect(json['description'], 'Test promotion description');
    });

    test('should check promotion is active correctly', () {
      final now = DateTime.now();
      final activePromotion = Promotion(
        discount: 10.0,
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 1)),
      );

      final inactivePromotion = Promotion(
        discount: 10.0,
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 2)),
      );

      final noDiscountPromotion = Promotion(
        discount: 0.0,
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 1)),
      );

      expect(activePromotion.isActive, true);
      expect(inactivePromotion.isActive, false);
      expect(noDiscountPromotion.isActive, false);
    });
  });
} 