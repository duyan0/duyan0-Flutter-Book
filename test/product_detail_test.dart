import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/features/product/screens/product_detail_screen.dart';

void main() {
  group('Product Detail Screen Tests', () {
    testWidgets('should display product details without product ID', (WidgetTester tester) async {
      final product = Product(
        productId: 1,
        title: 'Test Book',
        description: 'This is a test book description that should be displayed in the detail screen.',
        price: 150000.0,
        image: '/images/test.jpg',
        quantity: 10,
        status: 'Còn hàng',
        isbn: '1234567890123',
        pageCount: 200,
        language: 'Tiếng Việt',
        publicationDate: DateTime(2024, 1, 1),
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
          bio: 'Test author biography',
        ),
        publisher: Publisher(
          id: 'pub-id',
          publisherId: 1,
          name: 'Test Publisher',
          address: 'Test Address',
          phone: '0123456789',
          email: 'test@publisher.com',
        ),
        promotion: Promotion(
          id: 'promo-id',
          promotionId: 1,
          name: 'Test Promotion',
          discount: 15.0,
          description: 'Test promotion description',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Verify that product ID is not displayed
      expect(find.text('ID: 1'), findsNothing);
      expect(find.text('Product ID: 1'), findsNothing);
      expect(find.text('Mã sản phẩm: 1'), findsNothing);

      // Verify that other product details are displayed
      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('This is a test book description that should be displayed in the detail screen.'), findsOneWidget);
      expect(find.text('150.000 đ'), findsOneWidget);
      expect(find.text('127.500 đ'), findsOneWidget); // Discounted price
      expect(find.text('15%'), findsOneWidget); // Discount percentage
      expect(find.text('Còn hàng'), findsOneWidget);
      expect(find.text('10'), findsOneWidget); // Quantity
      expect(find.text('1234567890123'), findsOneWidget); // ISBN
      expect(find.text('200'), findsOneWidget); // Page count
      expect(find.text('Tiếng Việt'), findsOneWidget); // Language
      expect(find.text('01/01/2024'), findsOneWidget); // Publication date
      expect(find.text('Văn học'), findsOneWidget); // Category
      expect(find.text('Test Author'), findsOneWidget); // Author
      expect(find.text('Việt Nam'), findsOneWidget); // Author country
      expect(find.text('Test author biography'), findsOneWidget); // Author bio
      expect(find.text('Test Publisher'), findsOneWidget); // Publisher
      expect(find.text('Test Address'), findsOneWidget); // Publisher address
      expect(find.text('0123456789'), findsOneWidget); // Publisher phone
      expect(find.text('test@publisher.com'), findsOneWidget); // Publisher email
      expect(find.text('Test Promotion'), findsOneWidget); // Promotion name
      expect(find.text('Test promotion description'), findsOneWidget); // Promotion description
    });

    testWidgets('should display product without promotion', (WidgetTester tester) async {
      final product = Product(
        productId: 2,
        title: 'Regular Book',
        description: 'A book without promotion.',
        price: 100000.0,
        image: '/images/regular.jpg',
        quantity: 5,
        status: 'Còn hàng',
        isbn: '9876543210987',
        pageCount: 150,
        language: 'Tiếng Anh',
        publicationDate: DateTime(2023, 6, 15),
        category: Category(
          id: 'cat-id-2',
          categoryId: 2,
          name: 'Kinh tế',
        ),
        author: Author(
          id: 'author-id-2',
          authorId: 2,
          name: 'Regular Author',
          country: 'Mỹ',
        ),
        publisher: Publisher(
          id: 'pub-id-2',
          publisherId: 2,
          name: 'Regular Publisher',
          address: 'Regular Address',
          phone: '0987654321',
          email: 'regular@publisher.com',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Verify that product ID is not displayed
      expect(find.text('ID: 2'), findsNothing);
      expect(find.text('Product ID: 2'), findsNothing);

      // Verify that other product details are displayed
      expect(find.text('Regular Book'), findsOneWidget);
      expect(find.text('A book without promotion.'), findsOneWidget);
      expect(find.text('100.000 đ'), findsOneWidget);
      expect(find.text('Còn hàng'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // Quantity
      expect(find.text('9876543210987'), findsOneWidget); // ISBN
      expect(find.text('150'), findsOneWidget); // Page count
      expect(find.text('Tiếng Anh'), findsOneWidget); // Language
      expect(find.text('15/06/2023'), findsOneWidget); // Publication date
      expect(find.text('Kinh tế'), findsOneWidget); // Category
      expect(find.text('Regular Author'), findsOneWidget); // Author
      expect(find.text('Mỹ'), findsOneWidget); // Author country
      expect(find.text('Regular Publisher'), findsOneWidget); // Publisher
      expect(find.text('Regular Address'), findsOneWidget); // Publisher address
      expect(find.text('0987654321'), findsOneWidget); // Publisher phone
      expect(find.text('regular@publisher.com'), findsOneWidget); // Publisher email

      // Verify that promotion-related elements are not displayed
      expect(find.text('Test Promotion'), findsNothing);
      expect(find.text('15%'), findsNothing);
      expect(find.text('127.500 đ'), findsNothing);
    });

    testWidgets('should display product with missing optional fields', (WidgetTester tester) async {
      final product = Product(
        productId: 3,
        title: 'Minimal Book',
        description: 'A book with minimal information.',
        price: 50000.0,
        image: '/images/minimal.jpg',
        quantity: 1,
        status: 'Còn hàng',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Verify that product ID is not displayed
      expect(find.text('ID: 3'), findsNothing);
      expect(find.text('Product ID: 3'), findsNothing);

      // Verify that basic product details are displayed
      expect(find.text('Minimal Book'), findsOneWidget);
      expect(find.text('A book with minimal information.'), findsOneWidget);
      expect(find.text('50.000 đ'), findsOneWidget);
      expect(find.text('Còn hàng'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // Quantity

      // Verify that optional fields are handled gracefully
      expect(find.text('ISBN:'), findsOneWidget);
      expect(find.text('Số trang:'), findsOneWidget);
      expect(find.text('Ngôn ngữ:'), findsOneWidget);
      expect(find.text('Ngày xuất bản:'), findsOneWidget);
      expect(find.text('Danh mục:'), findsOneWidget);
      expect(find.text('Tác giả:'), findsOneWidget);
      expect(find.text('Nhà xuất bản:'), findsOneWidget);
    });

    testWidgets('should display out of stock product correctly', (WidgetTester tester) async {
      final product = Product(
        productId: 4,
        title: 'Out of Stock Book',
        description: 'This book is out of stock.',
        price: 200000.0,
        image: '/images/outofstock.jpg',
        quantity: 0,
        status: 'Hết hàng',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Verify that product ID is not displayed
      expect(find.text('ID: 4'), findsNothing);
      expect(find.text('Product ID: 4'), findsNothing);

      // Verify that out of stock status is displayed
      expect(find.text('Out of Stock Book'), findsOneWidget);
      expect(find.text('This book is out of stock.'), findsOneWidget);
      expect(find.text('200.000 đ'), findsOneWidget);
      expect(find.text('Hết hàng'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Quantity
    });

    testWidgets('should handle null values gracefully', (WidgetTester tester) async {
      final product = Product(
        productId: 5,
        title: 'Null Book',
        description: null,
        price: null,
        image: null,
        quantity: null,
        status: null,
        isbn: null,
        pageCount: null,
        language: null,
        publicationDate: null,
        category: null,
        author: null,
        publisher: null,
        promotion: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Verify that product ID is not displayed
      expect(find.text('ID: 5'), findsNothing);
      expect(find.text('Product ID: 5'), findsNothing);

      // Verify that title is displayed (required field)
      expect(find.text('Null Book'), findsOneWidget);

      // Verify that null values are handled gracefully
      expect(find.text('Mô tả:'), findsOneWidget);
      expect(find.text('Giá:'), findsOneWidget);
      expect(find.text('Trạng thái:'), findsOneWidget);
      expect(find.text('Số lượng:'), findsOneWidget);
      expect(find.text('ISBN:'), findsOneWidget);
      expect(find.text('Số trang:'), findsOneWidget);
      expect(find.text('Ngôn ngữ:'), findsOneWidget);
      expect(find.text('Ngày xuất bản:'), findsOneWidget);
      expect(find.text('Danh mục:'), findsOneWidget);
      expect(find.text('Tác giả:'), findsOneWidget);
      expect(find.text('Nhà xuất bản:'), findsOneWidget);
    });
  });
} 