import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/models/genre.dart';
import 'package:bookstore/services/genre_service.dart';
import 'package:bookstore/core/navigation/admin_routes.dart';
import 'package:bookstore/features/admin/presentation/widgets/admin_drawer.dart';

class GenreListPage extends StatefulWidget {
  const GenreListPage({super.key});

  @override
  State<GenreListPage> createState() => _GenreListPageState();
}

class _GenreListPageState extends State<GenreListPage> {
  final GenreService _genreService = GenreService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Genre> _genres = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _pageSize = 10;
  
  // New genre dialog
  final TextEditingController _genreNameController = TextEditingController();
  final TextEditingController _genreDescController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadGenres();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _genreNameController.dispose();
    _genreDescController.dispose();
    super.dispose();
  }
  
  Future<void> _loadGenres({String? searchTerm}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final result = await _genreService.getGenres(
        page: _currentPage,
        pageSize: _pageSize,
        searchTerm: searchTerm,
      );
      
      setState(() {
        _genres = result['genres'] as List<Genre>;
        final pagination = result['pagination'] as Map<String, dynamic>;
        _currentPage = pagination['currentPage'] as int;
        _totalPages = pagination['totalPages'] as int;
        _totalItems = pagination['totalCount'] as int;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách thể loại: $e';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _deleteGenre(int id) async {
    try {
      final result = await _genreService.deleteGenre(id);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa thể loại thành công')),
        );
        _loadGenres(searchTerm: _searchController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa thể loại thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
  
  void _showDeleteConfirmation(Genre genre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa thể loại "${genre.tenTheLoai}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGenre(genre.maTheLoai);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  Future<void> _showAddGenreDialog() async {
    _genreNameController.clear();
    _genreDescController.clear();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm thể loại mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _genreNameController,
              decoration: const InputDecoration(
                labelText: 'Tên thể loại',
                hintText: 'Nhập tên thể loại',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _genreDescController,
              decoration: const InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
                hintText: 'Nhập mô tả thể loại',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (_genreNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tên thể loại không được để trống')),
                );
                return;
              }
              
              try {
                await _genreService.createGenre(
                  _genreNameController.text,
                  moTa: _genreDescController.text.isNotEmpty ? _genreDescController.text : null,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thêm thể loại thành công')),
                  );
                  _loadGenres(searchTerm: _searchController.text);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _showEditGenreDialog(Genre genre) async {
    _genreNameController.text = genre.tenTheLoai;
    _genreDescController.text = genre.moTa ?? '';
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thể loại'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _genreNameController,
              decoration: const InputDecoration(
                labelText: 'Tên thể loại',
                hintText: 'Nhập tên thể loại',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _genreDescController,
              decoration: const InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
                hintText: 'Nhập mô tả thể loại',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (_genreNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tên thể loại không được để trống')),
                );
                return;
              }
              
              try {
                await _genreService.updateGenre(
                  genre.maTheLoai,
                  _genreNameController.text,
                  moTa: _genreDescController.text.isNotEmpty ? _genreDescController.text : null,
                  trangThai: genre.trangThai,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thể loại thành công')),
                  );
                  _loadGenres(searchTerm: _searchController.text);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thể loại'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGenreDialog,
            tooltip: 'Thêm thể loại mới',
          ),
        ],
      ),
      drawer: AdminDrawer(currentPath: AdminRoutes.genres),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thể loại...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadGenres();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => _loadGenres(searchTerm: value),
            ),
          ),
          
          // Error message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          
          // Loading indicator or data table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _genres.isEmpty
                    ? const Center(child: Text('Không có thể loại nào'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Tên thể loại')),
                              DataColumn(label: Text('Mô tả')),
                              DataColumn(label: Text('Trạng thái')),
                              DataColumn(label: Text('Danh mục')),
                              DataColumn(label: Text('Thao tác')),
                            ],
                            rows: _genres.map((genre) {
                              return DataRow(
                                cells: [
                                  DataCell(Text('${genre.maTheLoai}')),
                                  DataCell(Text(genre.tenTheLoai)),
                                  DataCell(Text(genre.moTa ?? 'N/A')),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: genre.trangThai ? Colors.green[100] : Colors.red[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        genre.trangThai ? 'Hoạt động' : 'Không hoạt động',
                                        style: TextStyle(
                                          color: genre.trangThai ? Colors.green[800] : Colors.red[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    genre.danhMuc.isNotEmpty
                                        ? Text(genre.danhMuc.map((c) => c.tenDanhMuc).join(', '))
                                        : const Text('Không có', style: TextStyle(fontStyle: FontStyle.italic)),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _showEditGenreDialog(genre),
                                          tooltip: 'Sửa',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _showDeleteConfirmation(genre),
                                          tooltip: 'Xóa',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
          ),
          
          // Pagination controls
          if (!_isLoading && _genres.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed: _currentPage > 1
                        ? () {
                            _currentPage = 1;
                            _loadGenres(searchTerm: _searchController.text);
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: _currentPage > 1
                        ? () {
                            _currentPage--;
                            _loadGenres(searchTerm: _searchController.text);
                          }
                        : null,
                  ),
                  Text(
                    'Trang $_currentPage/$_totalPages (Tổng: $_totalItems)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_next),
                    onPressed: _currentPage < _totalPages
                        ? () {
                            _currentPage++;
                            _loadGenres(searchTerm: _searchController.text);
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: _currentPage < _totalPages
                        ? () {
                            _currentPage = _totalPages;
                            _loadGenres(searchTerm: _searchController.text);
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 