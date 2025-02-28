import 'package:fake_store_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결제하기')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final cartProvider = Provider.of<CartProvider>(
              context,
              listen: false,
            );
            final double totalAmount = cartProvider.totalPrice;

            // 결제 완료 후 장바구니 비우기
            _processPayment(totalAmount, cartProvider.items);
          },
          child: const Text('결제하기'),
        ),
      ),
    );
  }

  void _processPayment(double totalAmount, List<CartItem> items) async {
    // 폼 검증
    // 폼 데이터 저장

    // 결제 API 호출
    final result = await _paymentService.processPayment(
      amount: totalAmount,
      shippingAddress: {
        'address1': '서울시 강남구',
        'city': '서울',
        'postal_code': '12345',
        'country': 'KR',
      },
      items: items,
    );

    print('결제 결과: $result');
  }
}
