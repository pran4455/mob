import 'package:flutter/material.dart';
import '../models/products.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> _cartItems = {}; // {productId: quantity}

  Map<int, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] = _cartItems[product.id]! + 1;
    } else {
      _cartItems[product.id] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    _cartItems.forEach((id, quantity) {
      total += demoProducts.firstWhere((prod) => prod.id == id).price * quantity;
    });
    return total;
  }
}
