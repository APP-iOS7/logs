import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    return ListTile(
      title: Text('${product.title} x ${cartItem.quantity}'),
      subtitle: Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
    );
  }
}
