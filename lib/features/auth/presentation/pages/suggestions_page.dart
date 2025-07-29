import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/services/product_service.dart';
import 'package:bookstore/models/product.dart';
import 'package:bookstore/features/book/presentation/pages/book_detail_page.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  late Future<List<Product>> _suggestedProductsFuture;

  @override
  void initState() {
    super.initState();
    _suggestedProductsFuture = ProductService.getAllProducts();
  }

  void _showFeatureInDevelopment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang phát triển'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFC92127),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gợi ý cho bạn'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _suggestedProductsFuture = ProductService.getAllProducts();
          });
        },
        child: FutureBuilder<List<Product>>(
          future: _suggestedProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có sản phẩm gợi ý nào.'));
            }

            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final bool hasDiscount = product.promotion != null && product.promotion!.discount != null && product.promotion!.discount! > 0;
                final double price = product.price ?? 0;
                final double discount = hasDiscount ? product.promotion!.discount! : 0;
                final double priceAfterDiscount = hasDiscount ? calculateDiscountedPrice(price, discount) : price;
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            product.hinhAnhUrl ?? 'http://10.0.2.2:5070/uploads/default.jpg',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.book, size: 44, color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            product.title ?? 'Không có tiêu đề',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (hasDiscount) ...[
                                    Text(
                                      _formatCurrency(price),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '-${discount.toInt()}%',
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatCurrency(priceAfterDiscount),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double calculateDiscountedPrice(double price, double discount) {
    return price * (1 - discount / 100);
  }

  String _formatCurrency(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.") + ' đ';
  }
} 