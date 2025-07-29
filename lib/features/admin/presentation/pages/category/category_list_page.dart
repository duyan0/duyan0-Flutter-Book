import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/services/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_app_bar.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  bool _isLoading = true;
  List<dynamic> _categories = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCategories = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await AdminService().getCategories();
      if (result['success'] && result['data'] != null) {
        final data = result['data'];
        List categories = [];
        if (data['\$values'] != null) {
          categories = data['\$values'];
        }
        _totalCategories = categories.length;
        _totalPages = (_totalCategories / _pageSize).ceil();
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Quản lý danh mục'),
      drawer: AdminDrawer(currentPath: AdminRoutes.categories),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng số: $_totalCategories danh mục',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go(AdminRoutes.categoryCreate);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm danh mục'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                    ? const Center(child: Text('Không có danh mục nào'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 2,
                          child: ListView(
                            children: [
                              Container(
                                color: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 50, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 16),
                                    Expanded(flex: 2, child: Text('Tên danh mục', style: TextStyle(fontWeight: FontWeight.bold))),
                                    SizedBox(width: 120, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              ...List.generate(
                                _categories.length,
                                (index) => _buildCategoryRow(_categories[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(dynamic category) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(width: 50, child: Text('${category['id']}')),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: Text(category['name'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(
              width: 120,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      context.go(
                        AdminRoutes.categoryEdit,
                        extra: {'categoryId': category['id']},
                      );
                    },
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // TODO: Thêm xác nhận và xóa danh mục
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
} 