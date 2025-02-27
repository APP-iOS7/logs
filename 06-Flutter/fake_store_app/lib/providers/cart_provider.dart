import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final String _storageKey = 'cart_data';

  CartProvider() {
    _loadCartFromPrefs();
  }

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
    0.0,
    (total, current) => total + current.product.price * current.quantity,
  );

  int get itemCount =>
      _items.fold(0, (total, current) => total + current.quantity);

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    // 상품이 장바구니에 없으면 추가, 있으면 수량만 변경
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: quantity));
    } else {
      // 수량 변경시 기존 카트 아이템을 사용하는 것이 아니라 새로운 카트 아이템을 생성
      // 불변 객체를 사용하여 상태 관리를 쉽게 함
      _items[index] = _items[index].copyWith(
        newQuantity: _items[index].quantity + quantity,
      );
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(newQuantity: quantity);
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(cartData));
  }

  Future<void> _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartDataString = prefs.getString(_storageKey);

      if (cartDataString != null) {
        final List<dynamic> cartDataList =
            jsonDecode(cartDataString) as List<dynamic>;
        _items.clear();
        _items = cartDataList.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }
}
