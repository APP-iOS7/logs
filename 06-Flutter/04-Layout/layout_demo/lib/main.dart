import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('반응형 UI 예제')),
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            double fontSize = constraints.maxWidth > 600 ? 32 : 24;
            return Center(
              child: Text('반응형 텍스트', style: TextStyle(fontSize: fontSize)),
            );
          },
        ),
      ),
    );
  }
}
