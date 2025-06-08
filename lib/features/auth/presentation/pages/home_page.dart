import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';
import 'package:bookstore/core/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  bool _isLoading = true; // Trạng thái loading
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  final int _unreadNotifications = 3;

  @override
  void initState() {
    super.initState();
    // Tắt loading sau 2 giây
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.news);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
      case 3:
        context.go(AppRoutes.notifications);
        break;
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _showBookDetails(BuildContext context, String title) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryColor, // #C92127
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tác giả: Tác giả giả lập'),
                const SizedBox(height: 8),
                const Text('Giá: 100,000 VNĐ'),
                const SizedBox(height: 8),
                const Text('Mô tả: Đây là một cuốn sách tuyệt vời!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Đóng',
                  style: TextStyle(color: AppColors.secondaryColor), // #FFC107
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // #F5F5F5
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // #C92127
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sách...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon:
                        _searchHistory.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.history,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder:
                                      (context) => ListView(
                                        children:
                                            _searchHistory
                                                .map(
                                                  (query) => ListTile(
                                                    title: Text(query),
                                                    onTap: () {
                                                      _searchController.text =
                                                          query;
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Tìm kiếm: $query',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                );
                              },
                            )
                            : null,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      if (!_searchHistory.contains(value)) {
                        setState(() {
                          _searchHistory.insert(0, value);
                          if (_searchHistory.length > 5)
                            _searchHistory.removeLast();
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tìm kiếm: $value')),
                      );
                    }
                  },
                )
                : const Text(
                  'BookStore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora',
                  ),
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner vuốt qua lại
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 0.8,
                      ),
                      items:
                          [
                            'lib/core/assets/hks_1.jpeg',
                            'lib/core/assets/hks_1.jpeg',
                            'lib/core/assets/hks_1.jpeg',
                          ].map((path) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Danh mục sách
                    Text(
                      'Danh mục sách',
                      style: TextStyle(
                        color: AppColors.primaryColor, // #C92127
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            [
                              {
                                'name': 'Văn học',
                                'image': 'lib/core/assets/hks_1.jpeg',
                              },
                              {
                                'name': 'Khoa học',
                                'image': 'lib/core/assets/hks_1.jpeg',
                              },
                              {
                                'name': 'Kinh tế',
                                'image': 'lib/core/assets/hks_1.jpeg',
                              },
                              {
                                'name': 'Thiếu nhi',
                                'image': 'lib/core/assets/hks_1.jpeg',
                              },
                              {
                                'name': 'Tự truyện',
                                'image': 'lib/core/assets/hks_1.jpeg',
                              },
                            ].map((category) {
                              return GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Danh mục: ${category['name']}',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  category['image']!,
                                                ),
                                                fit: BoxFit.cover,
                                                onError:
                                                    (exception, stackTrace) =>
                                                        Container(
                                                          color: Colors.grey,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          if (_isLoading)
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                              child: const Center(
                                                child: CircularProgressIndicator(
                                                  color:
                                                      AppColors
                                                          .primaryColor, // #C92127
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        category['name']!,
                                        style: TextStyle(
                                          color: AppColors.textColor, // #333333
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sản phẩm bán chạy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sản phẩm bán chạy',
                          style: TextStyle(
                            color: AppColors.primaryColor, // #C92127
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Xem tất cả sách bán chạy'),
                              ),
                            );
                          },
                          child: Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: AppColors.secondaryColor, // #FFC107
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final title = 'Sách ${index + 1}';
                          return GestureDetector(
                            onTap: () => _showBookDetails(context, title),
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: const AssetImage(
                                              'lib/core/assets/hks_1.jpeg',
                                            ),
                                            fit: BoxFit.cover,
                                            onError:
                                                (exception, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      if (_isLoading)
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  AppColors
                                                      .primaryColor, // #C92127
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Đã thêm $title vào giỏ hàng',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: AppColors.textColor, // #333333
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '100,000 VNĐ',
                                    style: TextStyle(
                                      color: AppColors.primaryColor, // #C92127
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sản phẩm mua gần đây
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mua gần đây',
                          style: TextStyle(
                            color: AppColors.primaryColor, // #C92127
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Xem tất cả sách mua gần đây'),
                              ),
                            );
                          },
                          child: Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: AppColors.secondaryColor, // #FFC107
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final title = 'Sách gần đây ${index + 1}';
                          return GestureDetector(
                            onTap: () => _showBookDetails(context, title),
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: const AssetImage(
                                              'lib/core/assets/hks_1.jpeg',
                                            ),
                                            fit: BoxFit.cover,
                                            onError:
                                                (exception, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      if (_isLoading)
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  AppColors
                                                      .primaryColor, // #C92127
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Đã thêm $title vào giỏ hàng',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: AppColors.textColor, // #333333
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '100,000 VNĐ',
                                    style: TextStyle(
                                      color: AppColors.primaryColor, // #C92127
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primaryColor, // #C92127
        unselectedItemColor: AppColors.textColor, // #333333
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tin tức',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Thông báo',
          ),
        ],
      ),
    );
  }
}
