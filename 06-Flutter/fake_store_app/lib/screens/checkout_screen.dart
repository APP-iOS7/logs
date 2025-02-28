import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결제하기')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 결제 완료 후 장바구니 비우기
          },
          child: const Text('결제하기'),
        ),
      ),
    );
  }
}
