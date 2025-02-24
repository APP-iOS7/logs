import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = '버튼을 눌러주세요!'; // 상태 변수

  String inputText = ''; // 입력값을 저장할 변수

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('레이아웃 예제')),
        body: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey[200],
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
              // 텍스트 위젯
              Text(
                '안녕하세요, Flutter!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // 이미지 위젯
              Image.network(
                'https://picsum.photos/150',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 50),
              Text(
                message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    message = '버튼을 눌렀습니다!';
                  });
                },
                child: Text('Elevated Button'),
              ),
              // 텍스트 필드
              TextField(
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
                decoration: InputDecoration(hintText: '텍스트를 입력하세요.'),
              ),
              SizedBox(height: 20),
              Text('입력된 텍스트: $inputText'),
            ],
          ),
        ),
      ),
    );
  }
}
