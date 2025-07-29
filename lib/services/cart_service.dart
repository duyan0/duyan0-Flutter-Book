import 'package:bookstore/models/product.dart';

class CartService {
  static final List<CartItem> _cartItems = [];

  static void addToCart(Product product, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.productId == product.productId);
    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }

  static List<CartItem> getCartItems() {
    return List.unmodifiable(_cartItems);
  }

  static void clearCart() {
    _cartItems.clear();
  }

  // Thêm hàm xóa sản phẩm theo index
  static void removeAt(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  // Thêm hàm xóa sản phẩm theo productId
  static void removeByProductId(int productId) {
    _cartItems.removeWhere((item) => item.product.productId == productId);
  }
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
} 