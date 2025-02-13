import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView'), // AppBar에 'GridView'라는 제목을 표시합니다.
      ),
      body: GridView.builder(
        // GridView.builder를 사용하여 그리드 뷰를 생성합니다.
        scrollDirection: Axis.vertical, // 스크롤 방향을 수직으로 설정합니다.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // 그리드 뷰의 레이아웃을 설정합니다.
          crossAxisCount: 3, // 한 행에 3개의 아이템을 배치합니다.
          crossAxisSpacing: 10, // 아이템 간의 가로 간격을 10으로 설정합니다.
          mainAxisSpacing: 10, // 아이템 간의 세로 간격을 10으로 설정합니다.
        ),
        itemCount: 30, // 총 30개의 아이템을 생성합니다.
        itemBuilder: (context, index) {
          // 각 아이템을 생성하는 함수입니다.
          return Container(
            // 각 아이템은 Container 위젯으로 구성됩니다.
            color: Colors.blue[100 *
                (index %
                    9)], // 아이템의 배경색을 설정합니다.  index에 따라 파란색 계열의 다른 색상이 적용됩니다. (9가지 색상 반복)
            child: Center(
              // Container 내부에 내용을 중앙 정렬합니다.
              child: Text('Item $index'), // 'Item'과 함께 아이템의 인덱스를 텍스트로 표시합니다.
            ),
          );
        },
      ),
    );
  }
}
