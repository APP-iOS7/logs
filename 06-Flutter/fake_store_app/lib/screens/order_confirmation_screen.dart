import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();

    Order? order = orderProvider.getOrderById(orderId);

    return Scaffold(
      appBar: AppBar(title: const Text('결제 완료')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              Text('결제가 완료되었습니다.', style: TextStyle(fontSize: 20)),
              Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('주문번호: ${order?.id}'),
                      Text('결제 금액: \$${order?.totalAmount.toStringAsFixed(2)}'),
                      Text('결제 일시: ${order?.date}'),
                    ],
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('홈으로'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
