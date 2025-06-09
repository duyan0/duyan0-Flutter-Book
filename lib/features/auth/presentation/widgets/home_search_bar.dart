import 'package:flutter/material.dart';
import 'package:bookstore/core/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final List<String> searchHistory;
  final VoidCallback onToggleSearch;
  final Function(String) onSearchSubmitted;

  const HomeSearchBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchHistory,
    required this.onToggleSearch,
    required this.onSearchSubmitted,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: isSearching
          ? Container(
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                     
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm sách...',
                       
                       
                        
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      onSubmitted: onSearchSubmitted,
                    ),
                  ),
                  if (searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                      splashRadius: 16,
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                  const SizedBox(width: 4),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, color: Colors.white, size: 24),
                const SizedBox(width: 6),
                const Text(
                  'BookStore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Colors.white,
            size: 20,
          ),
          splashRadius: 20,
          onPressed: onToggleSearch,
        ),
      ],
    );
  }
} 