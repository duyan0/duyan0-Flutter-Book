import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookstore/models/product.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:5070/api/SanPham';
  
  // Lấy tất cả sản phẩm
  static Future<List<Product>> getAllProducts() async {
    try {
      print('🔍 Đang lấy tất cả sản phẩm');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Parsed data structure: ${data.runtimeType}');
        
        List<Product> products = [];
        
        // Xử lý cấu trúc response theo sanpham.txt
        if (data['success'] == true && data['data'] != null) {
          print('✅ API trả về thành công, kiểm tra cấu trúc data');
          
          if (data['data'] is Map && data['data']['\$values'] != null) {
            print('📋 Data có cấu trúc \$values, xử lý...');
            final List productsJson = data['data']['\$values'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
            print('📋 Đã parse được ${products.length} sản phẩm từ \$values');
          } else if (data['data'] is List) {
            print('📋 Data là List, số lượng: ${data['data'].length}');
            final List productsJson = data['data'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
          }
        }
        
        print('📋 Số lượng sản phẩm tìm thấy: ${products.length}');
        if (products.isNotEmpty) {
          print('📚 Mẫu sản phẩm đầu tiên: ${products.first.title}');
        }
        
        return products;
      } else {
        print('❌ Lấy sản phẩm thất bại! Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('💥 Lỗi khi lấy sản phẩm: $e');
      return [];
    }
  }
  
  // Tìm kiếm sản phẩm theo từ khóa
  static Future<List<Product>> searchProducts(String keyword) async {
    try {
      print('🔍 Đang tìm kiếm sản phẩm với từ khóa: $keyword');
      
      // Thử endpoint tìm kiếm nếu có
      final String searchUrl = '$baseUrl/search?keyword=$keyword';
      print('🔗 Search URL: $searchUrl');
      
      final response = await http.get(
        Uri.parse(searchUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> products = [];
        
        if (data['success'] == true && data['data'] != null) {
          if (data['data'] is Map && data['data']['\$values'] != null) {
            final List productsJson = data['data']['\$values'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
          } else if (data['data'] is List) {
            final List productsJson = data['data'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
          }
        }
        
        print('🔍 Tìm thấy ${products.length} sản phẩm với từ khóa: $keyword');
        return products;
      } else {
        print('❌ API tìm kiếm không khả dụng, thử phương pháp lọc thủ công');
        
        // Nếu API tìm kiếm không khả dụng, lấy tất cả sản phẩm và lọc
        final allProducts = await getAllProducts();
        final keyword_lower = keyword.toLowerCase();
        
        final filteredProducts = allProducts.where((product) {
          final title = product.title?.toLowerCase() ?? '';
          final description = product.description?.toLowerCase() ?? '';
          final author = product.author?.name?.toLowerCase() ?? '';
          final publisher = product.publisher?.name?.toLowerCase() ?? '';
          final category = product.category?.name?.toLowerCase() ?? '';
          
          return title.contains(keyword_lower) || 
                 description.contains(keyword_lower) ||
                 author.contains(keyword_lower) ||
                 publisher.contains(keyword_lower) ||
                 category.contains(keyword_lower);
        }).toList();
        
        print('🔍 Tìm thấy ${filteredProducts.length} sản phẩm với từ khóa: $keyword (lọc thủ công)');
        return filteredProducts;
      }
    } catch (e) {
      print('💥 Lỗi khi tìm kiếm sản phẩm: $e');
      return [];
    }
  }
  
  // Lấy sản phẩm theo danh mục
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      print('🔍 Đang lấy sản phẩm theo danh mục: $categoryId');
      
      final String categoryUrl = '$baseUrl/category/$categoryId';
      print('🔗 Category URL: $categoryUrl');
      
      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> products = [];
        
        if (data['success'] == true && data['data'] != null) {
          if (data['data'] is Map && data['data']['\$values'] != null) {
            final List productsJson = data['data']['\$values'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
          } else if (data['data'] is List) {
            final List productsJson = data['data'] as List;
            products = productsJson.map((json) => Product.fromJson(json)).toList();
          }
        }
        
        print('🔍 Tìm thấy ${products.length} sản phẩm thuộc danh mục: $categoryId');
        return products;
      } else {
        print('❌ API danh mục không khả dụng, thử phương pháp lọc thủ công');
        
        // Nếu API danh mục không khả dụng, lấy tất cả sản phẩm và lọc
        final allProducts = await getAllProducts();
        
        final filteredProducts = allProducts.where((product) => 
          product.category?.id == categoryId
        ).toList();
        
        print('🔍 Tìm thấy ${filteredProducts.length} sản phẩm thuộc danh mục: $categoryId (lọc thủ công)');
        return filteredProducts;
      }
    } catch (e) {
      print('💥 Lỗi khi lấy sản phẩm theo danh mục: $e');
      return [];
    }
  }
  
  // Lấy sản phẩm theo ID
  static Future<Product?> getProductById(int productId) async {
    try {
      print('🔍 Đang lấy sản phẩm với ID: $productId');
      
      final String productUrl = '$baseUrl/$productId';
      print('🔗 Product URL: $productUrl');
      
      final response = await http.get(
        Uri.parse(productUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['data'] != null) {
          final product = Product.fromJson(data['data']);
          print('✅ Đã lấy thông tin sản phẩm: ${product.title}');
          return product;
        }
        
        print('❌ Không tìm thấy sản phẩm với ID: $productId');
        return null;
      } else {
        print('❌ Lấy sản phẩm thất bại! Status code: ${response.statusCode}');
        
        // Thử phương pháp lọc từ danh sách
        final allProducts = await getAllProducts();
        final product = allProducts.firstWhere(
          (p) => p.productId == productId,
          orElse: () => Product(),
        );
        
        if (product.productId != null) {
          print('✅ Đã tìm thấy sản phẩm từ danh sách: ${product.title}');
          return product;
        }
        
        return null;
      }
    } catch (e) {
      print('💥 Lỗi khi lấy sản phẩm theo ID: $e');
      return null;
    }
  }
}
