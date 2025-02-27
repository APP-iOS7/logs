import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // 장바구니 비우기
            },
          ),
        ],
      ),
      body: const Center(child: Text('장바구니 화면')),
    );
  }
}
