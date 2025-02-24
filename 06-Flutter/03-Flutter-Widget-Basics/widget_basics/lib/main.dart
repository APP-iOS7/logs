import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('레이아웃 예제')),
        body: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    child: Text('위젯 1'),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green,
                    child: Text('위젯 2'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue,
                child: Text('위젯 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
