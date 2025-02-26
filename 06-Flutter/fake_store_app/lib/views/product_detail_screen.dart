import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/quantity_selector.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              data.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
            ),
            Text(
              data.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${data.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(data.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${data.rating['rate']} (${data.rating['count']})',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 수량 선택
            QuantitySelector(),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text(
                  '장바구니에 담기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
