import 'product.dart';

// 개별 상품의 장바구니 아이템
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // 개별 상품의 총 가격 (수량 * 가격)
  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  // 수량을 변경한 새로운 CartItem을 반환 (불변성 유지)
  CartItem copyWith({int? newQuantity}) {
    return CartItem(product: product, quantity: newQuantity ?? quantity);
  }
}
