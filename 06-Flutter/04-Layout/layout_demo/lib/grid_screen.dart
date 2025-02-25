import 'package:flutter/material.dart';

class GridScreen extends StatelessWidget {
  GridScreen({super.key});

  final List<String> items = List.generate(100, (index) => 'Item ${index + 1}');
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GridView 예제')),
        // Scrollbar 추가: GridView가 화면을 벗어날 때 스크롤바 표시
        body: Scrollbar(
          // 가로 스크롤바를 표시하기 위한 설정
          controller: _scrollController,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return Container(
                // 색상을 인덱스에 따라 다르게 지정: 100씩 증가 [100, 200, ..., 900]
                color: Colors.blue[100 * ((index % 9) + 1)],
                child: Center(child: Text(item)),
              );
            },
          ),
        ),
      ),
    );
  }
}
