import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> products;
  String _searchText = ''; // 검색어를 저장하는 변수

  @override
  void initState() {
    super.initState();
    products = ApiService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 목록')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: '검색어를 입력하세요'),
            ),
          ),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return const Placeholder();
  }
}
