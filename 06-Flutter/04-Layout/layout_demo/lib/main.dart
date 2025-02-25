import 'package:flutter/material.dart';

import 'grid_screen.dart';

void main() {
  runApp(GridScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('반응형 UI 예제')),
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                double fontSize = constraints.maxWidth > 600 ? 32 : 24;
                return Center(
                  child: Text('반응형 텍스트', style: TextStyle(fontSize: fontSize)),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  flex: 2, // 2:1 비율
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    child: Text('위젯 1'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green,
                    child: Text('위젯 2'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
