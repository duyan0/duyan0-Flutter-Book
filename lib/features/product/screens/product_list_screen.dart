import 'package:flutter/material.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/services/product_service.dart';
import 'package:bookstore/features/auth/presentation/widgets/home_search_bar.dart';
import 'package:bookstore/features/book/presentation/pages/book_detail_page.dart';
import 'package:bookstore/features/product/screens/product_search_screen.dart';
import 'package:intl/intl.dart';

class ProductListScreen extends StatefulWidget {
  final String? title;
  final int? categoryId;
  
  const ProductListScreen({
    Key? key,
    this.title,
    this.categoryId,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      List<Product> products;
      
      if (widget.categoryId != null) {
        products = await ProductService.getProductsByCategory(widget.categoryId!);
      } else {
        products = await ProductService.getAllProducts();
      }
      
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi khi tải sản phẩm: $e';
        _isLoading = false;
      });
    }
  }
  
  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSearchScreen(
          initialQuery: _searchController.text,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title ?? 'Tất cả sản phẩm'),
        backgroundColor: const Color(0xFFC92127),
        elevation: 0,
      ),
      body: Column(
        children: [
          HomeSearchBar(
            controller: _searchController,
            onSearch: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSearchScreen(initialQuery: query),
                ),
              );
            },
          ),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC92127),
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    
    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'Không có sản phẩm nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }
  
  Widget _buildProductCard(Product product) {
    // Get original price and check if product has discount
    final double originalPrice = product.price ?? 0;
    final bool hasDiscount = product.promotion != null && 
                            product.promotion!.discount != null && 
                            product.promotion!.discount! > 0;
    
    // Calculate discounted price if there's a discount
    final double discountPercentage = hasDiscount ? product.promotion!.discount! : 0;
    final double discountedPrice = hasDiscount 
        ? originalPrice * (1 - discountPercentage / 100) 
        : originalPrice;
    
    // Format prices for display
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final formattedOriginalPrice = formatter.format(originalPrice);
    final formattedDiscountedPrice = formatter.format(discountedPrice);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm với badge giảm giá
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Container(
                    height: 170,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: product.hinhAnhUrl != null
                        ? Image.network(
                            product.hinhAnhUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(Icons.book, size: 40, color: Colors.grey),
                          ),
                  ),
                ),
                // Badge giảm giá
                if (hasDiscount)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC92127),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '-${discountPercentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tiêu đề sách
                  Text(
                    product.title ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Giá gốc (nếu có giảm giá)
                  if (hasDiscount)
                    Text(
                      formattedOriginalPrice,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  // Giá sau giảm giá hoặc giá gốc
                  Text(
                    hasDiscount ? formattedDiscountedPrice : formattedOriginalPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFFC92127),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 