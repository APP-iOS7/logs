import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  static const String _storageKey = 'order_data';

  OrderProvider() {
    _loadOrdersFromPrefs();
  }

  List<Order> get orders => _orders;

  Future<void> addOrder({
    required String orderId,
    required List<CartItem> items,
    required double totalAmount,
    required Map<String, String> shippingAddress,
    required String paymentMethod,
  }) async {
    final newOrder = Order(
      id: orderId,
      items: items,
      totalAmount: totalAmount,
      date: DateTime.now(),
      status: '주문 완료',
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    _orders.add(newOrder);
    _saveOrdersToPrefs();
    notifyListeners();
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (error) {
      print('주문을 찾는 중 오류 발생: $error');
      return null;
    }
  }

  void _loadOrdersFromPrefs() async {
    // SharedPreferences에 저장된 주문 데이터를 불러와서 _orders에 저장
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderDataString = prefs.getString(_storageKey);
      if (orderDataString != null) {
        final orderDataList = jsonDecode(orderDataString) as List;
        _orders = orderDataList.map((item) => Order.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (error) {
      print('주문 데이터를 불러오는 중 오류 발생: $error');
    }
  }

  void _saveOrdersToPrefs() async {
    // _orders에 있는 주문 데이터를 SharedPreferences에 저장
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderData = _orders.map((order) => order.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(orderData));
    } catch (error) {
      print('주문 데이터를 저장하는 중 오류 발생: $error');
    }
  }
}
