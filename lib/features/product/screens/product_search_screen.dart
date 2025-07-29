import 'package:flutter/material.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/services/product_service.dart';
import 'package:bookstore/features/auth/presentation/widgets/book_item_card.dart';
import 'package:bookstore/features/auth/presentation/widgets/home_search_bar.dart';
import 'package:bookstore/features/book/presentation/pages/book_detail_page.dart';
import 'package:intl/intl.dart';

class ProductSearchScreen extends StatefulWidget {
  final String initialQuery;

  const ProductSearchScreen({
    Key? key,
    required this.initialQuery,
  }) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  late TextEditingController _searchController;
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchProducts(widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await ProductService.searchProducts(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi khi tìm kiếm: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tìm kiếm sản phẩm'),
        backgroundColor: const Color(0xFFC92127),
        elevation: 0,
      ),
      body: Column(
        children: [
          HomeSearchBar(
            controller: _searchController,
            autoFocus: true,
            onSearch: _searchProducts,
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
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
              onPressed: () => _searchProducts(_searchController.text),
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

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy sản phẩm nào cho "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _searchProducts(_searchController.text),
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
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
                    height: 130,
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