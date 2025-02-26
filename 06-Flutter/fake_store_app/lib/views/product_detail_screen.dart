import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> product;

  @override
  void initState() {
    super.initState();
    product = ApiService().getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세')),
      body: FutureBuilder(
        future: product,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('상품을 불러오는 중에 오류가 발생했습니다.'));
          }
          return _buildProductDetail(snapshot.data as Product);
        },
      ),
    );
  }

  Widget _buildProductDetail(Product data) {
    return Column(
      children: [
        Image.network(data.image),
        Text(data.title),
        Text('\$${data.price.toStringAsFixed(2)}'),
        Text(data.description),
      ],
    );
  }
}
