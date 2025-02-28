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

  List<CartItem> items = [];

  @override
  initState() {
    super.initState();
    // Cart 에서 결제할 상품 정보 가져오기
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    items = cartProvider.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결제하기')),
      body: SafeArea(
        child: Column(
          children: [
            // 결제 상품 목록
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final cartItem = items[index];
                  return ListTile(
                    title: Text(
                      '${cartItem.product.title} x ${cartItem.quantity}',
                    ),
                    subtitle: Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            // 합산 금액
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '총 결제 금액: \$${items.fold(0.0, (total, current) => total + current.totalPrice).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  final cartProvider = Provider.of<CartProvider>(
                    context,
                    listen: false,
                  );
                  final double totalAmount = cartProvider.totalPrice;

                  // 결제 완료 후 장바구니 비우기
                  _processPayment(totalAmount, cartProvider.items);
                },
                child: const Text(
                  '결제하기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
