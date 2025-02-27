import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        // 장바구니에서 상품 삭제
        final cartProvider = context.read<CartProvider>();
        cartProvider.removeItem(product.id);
      },
      child: ListTile(
        title: Text('${product.title} x ${cartItem.quantity}'),
        subtitle: Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
      ),
    );
  }
}
