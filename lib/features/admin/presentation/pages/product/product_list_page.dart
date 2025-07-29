import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:bookstore/models/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool _isLoading = true;
  List<Product> _products = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalProducts = 0;
  int _totalPages = 1;
  
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
    });
    
    try {
      final result = await AdminService().getProducts(
        page: _currentPage,
        pageSize: _pageSize,
      );
      
      if (result['success'] && result['data'] != null) {
        final data = result['data'];
        List<Product> products = [];
        
        if (data['data'] != null && data['data']['\$values'] != null) {
          final List productsJson = data['data']['\$values'];
          products = productsJson.map((json) => Product.fromJson(json)).toList();
          
          // Lọc theo từ khóa tìm kiếm nếu có
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            products = products.where((product) {
              final title = product.title?.toLowerCase() ?? '';
              final description = product.description?.toLowerCase() ?? '';
              final author = product.author?.name?.toLowerCase() ?? '';
              return title.contains(query) || 
                     description.contains(query) || 
                     author.contains(query);
            }).toList();
          }
          
          _totalProducts = data['totalCount'] ?? products.length;
          _totalPages = (_totalProducts / _pageSize).ceil();
        }
        
        setState(() {
          _products = products;
          _isLoading = false;
        });
      } else {
        setState(() {
          _products = [];
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _deleteProduct(int productId) async {
    try {
      final result = await AdminService().deleteProduct(productId);
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa sản phẩm thành công'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Tải lại danh sách sản phẩm
        _loadProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _showDeleteConfirmation(int productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa sản phẩm "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(productId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
  
  void _search() {
    _currentPage = 1; // Reset về trang đầu tiên khi tìm kiếm
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go(AdminRoutes.productCreate),
          ),
        ],
      ),
      drawer: AdminDrawer(currentPath: AdminRoutes.products),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                    },
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Text('Tìm kiếm'),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng số: $_totalProducts sản phẩm',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go(AdminRoutes.productCreate);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm sản phẩm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Products list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text('Không có sản phẩm nào'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 2,
                          child: ListView(
                            children: [
                              // Table header
                              Container(
                                color: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 50, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 16),
                                    Expanded(flex: 2, child: Text('Tên sản phẩm', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Tác giả', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Giá', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 120, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              
                              // Table rows
                              ...List.generate(
                                _products.length,
                                (index) => _buildProductRow(_products[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          
          // Pagination
          if (!_isLoading && _totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                            _loadProducts();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 16),
                  Text('Trang $_currentPage / $_totalPages'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _currentPage < _totalPages
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                            _loadProducts();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildProductRow(Product product) {
    final hasDiscount = product.promotion != null && 
                      product.promotion!.discount != null && 
                      product.promotion!.discount! > 0 &&
                      product.promotion!.isActive;
                      
    final price = product.price ?? 0;
    final discountPercent = hasDiscount ? product.promotion!.discount! : 0;
    final discountedPrice = hasDiscount ? price * (1 - discountPercent / 100) : price;
    
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            // ID
            SizedBox(
              width: 50,
              child: Text('${product.productId}'),
            ),
            const SizedBox(width: 16),
            
            // Tên sản phẩm
            Expanded(
              flex: 2,
              child: Text(
                product.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Tác giả
            Expanded(
              child: Text(
                product.author?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Danh mục
            Expanded(
              child: Text(
                product.category?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Giá
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasDiscount)
                    Text(
                      _formatCurrency(price),
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    _formatCurrency(discountedPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hasDiscount ? Colors.red : null,
                    ),
                  ),
                ],
              ),
            ),
            
            // Số lượng
            Expanded(
              child: Text('${product.quantity ?? 0}'),
            ),
            
            // Trạng thái
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (product.status == 'Còn hàng' || product.status == 'Available')
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.status ?? '',
                  style: TextStyle(
                    color: (product.status == 'Còn hàng' || product.status == 'Available')
                        ? Colors.green[800]
                        : Colors.red[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
            // Thao tác
            SizedBox(
              width: 120,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      context.go(
                        AdminRoutes.productEdit,
                        extra: {'productId': product.productId},
                      );
                    },
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(
                        product.productId ?? 0,
                        product.title ?? '',
                      );
                    },
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatCurrency(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.") + ' đ';
  }
} 