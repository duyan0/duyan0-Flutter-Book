import 'package:flutter/material.dart';
import 'package:bookstore/features/product/screens/product_search_screen.dart';

class HomeSearchBar extends StatelessWidget {
  final bool autoFocus;
  final TextEditingController? controller;
  final Function(String)? onSearch;
  
  const HomeSearchBar({
    Key? key,
    this.autoFocus = false,
    this.controller,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: controller,
                autofocus: autoFocus,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sách, tác giả...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (onSearch != null) {
                    onSearch!(value);
                  } else {
                    _navigateToSearch(context, value);
                  }
                },
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                controller!.clear();
              },
            ),
        ],
      ),
    );
  }
  
  void _navigateToSearch(BuildContext context, String query) {
    if (query.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductSearchScreen(initialQuery: query),
        ),
      );
    }
  }
} 