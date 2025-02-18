import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyWidget());
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final StreamController<String> _streamController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    _startSteam();
  }

  void _startSteam() {
    debugPrint('_startSteam');
    int count = 0;
    // StreamController를 통해 Stream을 생성
    Timer.periodic(Duration(seconds: 2), (timer) {
      count++;
      _streamController.add('데이터 $count');
      if (count == 10) {
        timer.cancel();
        _streamController.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StreamBuilder 예제')),
      body: StreamBuilder<String>(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          debugPrint('StreamBuilder: ${snapshot.connectionState}');
          // Stream이 연결되는 중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            // 스트림에 에러가 발생했을때
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
            // 스트림에 데이터가 없을때 (데이터가 로드되는 중에도 이 상태가 될 수 있음)
          } else if (!snapshot.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          }
          return Center(child: Text('StreamBuilder 예제 : ${snapshot.data}'));
        },
      ),
    );
  }
}
