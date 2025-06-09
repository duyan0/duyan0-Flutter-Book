import 'package:flutter/material.dart';
import 'package:bookstore/features/auth/presentation/widgets/book_item_card.dart';
import 'package:bookstore/features/product/screens/product_detail_screen.dart';
import 'package:go_router/go_router.dart';

class BookTabViewSection extends StatefulWidget {
  const BookTabViewSection({super.key});

  @override
  State<BookTabViewSection> createState() => _BookTabViewSectionState();
}

class _BookTabViewSectionState extends State<BookTabViewSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _trendingBooks = [
    {
      'image': 'lib/core/assets/8935235241848.jpeg',
      'title': 'Búp Sen Xanh - Bìa Cứng - Tặng Kèm...',
      'price': 110000,
      'rating': 5.0,
      'sold': '0',
    },
    {
      'image': 'lib/core/assets/8935235237773.jpeg',
      'title': 'Cánh Chim Bất Tử - Câu Chuyện Về Người Phi...',
      'price': 136000,
      'originalPrice': '177.000',
      'discount': 23,
      'sold': '0',
    },
    {
      'image': 'lib/core/assets/8935235234338.jpeg',
      'title': 'Mật Mã Davinci',
      'price': 120000,
      'originalPrice': '150.000',
      'discount': 20,
      'sold': '50+',
    },
     {
      'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
      'title': 'Mật Mã Davinci',
      'price': 120000,
      'originalPrice': '150.000',
      'discount': 20,
      'sold': '50+',
    },
     {
      'image': 'lib/core/assets/8934974182375.jpeg',
      'title': 'Mật Mã Davinci',
      'price': 120000,
      'originalPrice': '150.000',
      'discount': 20,
      'sold': '50+',
    },
     {
      'image': 'lib/core/assets/8934974180098_1.jpeg',
      'title': 'Mật Mã Davinci',
      'price': 120000,
      'originalPrice': '150.000',
      'discount': 20,
      'sold': '50+',
    },
     {
      'image': 'lib/core/assets/hks_1.jpeg',
      'title': 'Mật Mã Davinci',
      'price': 120000,
      'originalPrice': '150.000',
      'discount': 20,
      'sold': '50+',
    },
  ];

  final List<Map<String, dynamic>> _hotBooks = [
    {
      'image': 'lib/core/assets/8935235241848.jpeg',
      'title': 'Đắc Nhân Tâm',
      'price': 90000,
      'rating': 4.8,
      'sold': '200+',
    },
    {
      'image': 'lib/core/assets/8935235237773.jpeg',
      'title': 'Nhà Giả Kim',
      'price': 85000,
      'originalPrice': '100.000',
      'discount': 15,
      'sold': '180+',
    },
    {
      'image': 'lib/core/assets/8935235234338.jpeg',
      'title': 'Chiến Thắng Con Quỷ Trong Bạn',
      'price': 110000,
      'rating': 4.9,
      'sold': '120+',
    },
    {
      'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
      'title': 'Đắc Nhân Tâm',
      'price': 90000,
      'rating': 4.8,
      'sold': '200+',
    },
    {
      'image': 'lib/core/assets/8934974182375.jpeg',
      'title': 'Nhà Giả Kim',
      'price': 85000,
      'originalPrice': '100.000',
      'discount': 15,
      'sold': '180+',
    },
    {
      'image': 'lib/core/assets/8934974180098_1.jpeg',
      'title': 'Chiến Thắng Con Quỷ Trong Bạn',
      'price': 110000,
      'rating': 4.9,
      'sold': '120+',
    },
    {
      'image': 'lib/core/assets/hks_1.jpeg',
      'title': 'Đắc Nhân Tâm',
      'price': 90000,
      'rating': 4.8,
      'sold': '200+',
    },
    {
      'image': 'lib/core/assets/8935235237773.jpeg',
      'title': 'Nhà Giả Kim',
      'price': 85000,
      'originalPrice': '100.000',
      'discount': 15,
      'sold': '180+',
    },
    {
      'image': 'lib/core/assets/8935235234338.jpeg',
      'title': 'Chiến Thắng Con Quỷ Trong Bạn',
      'price': 110000,
      'rating': 4.9,
      'sold': '120+',
    },
    {
      'image': 'lib/core/assets/8935235217508_1120250417140043.jpeg',
      'title': 'Đắc Nhân Tâm',
      'price': 90000,
      'rating': 4.8,
      'sold': '200+',
    },
    {
      'image': 'lib/core/assets/8934974182375.jpeg',
      'title': 'Nhà Giả Kim',
      'price': 85000,
      'originalPrice': '100.000',
      'discount': 15,
      'sold': '180+',
    },
    {
      'image': 'lib/core/assets/8934974180098_1.jpeg',
      'title': 'Chiến Thắng Con Quỷ Trong Bạn',
      'price': 110000,
      'rating': 4.9,
      'sold': '120+',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Image.asset(
                'lib/core/assets/icon_trending.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Xu Hướng Theo Ngày',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        DefaultTabController(
          length: _tabController.length,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: const Color(0xFFC92127),
                  labelColor: const Color(0xFFC92127),
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  tabs: const [
                    Tab(text: 'Xu Hướng Theo Ngày'),
                    Tab(text: 'Sách HOT - Giảm Sốc'),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookList(_trendingBooks),
                    _buildBookList(_hotBooks),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookList(List<Map<String, dynamic>> books) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: books.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final book = books[index];
        return SizedBox(
          width: 150,
          child: BookItemCard(
            image: book['image'],
            title: book['title'],
            price: book['price'],
            rating: book['rating'],
            originalPrice: book['originalPrice'],
            discount: book['discount'],
            sold: book['sold'],
            isHotDeal: book['discount'] != null,
            onTap: () {
              context.push(
                '/home/product-detail',
                extra: {'image': book['image'], 'title': book['title']},
              );
            },
          ),
        );
      },
    );
  }
} 