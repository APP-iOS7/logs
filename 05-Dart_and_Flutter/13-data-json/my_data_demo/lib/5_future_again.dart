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
  String _data = '데이터를 불러오는 중입니다.';

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    // 일반함수에서 비동기 함수를 호출할 때는 then을 사용
    _loadData().then((value) {
      debugPrint('then');
      debugPrint('데이터 불러오기 완료');
    });
    debugPrint('initState 다른작업 1');
    debugPrint('initState 다른작업 2');
    debugPrint('initState 다른작업 3');
    debugPrint('initState 다른작업 4');
    debugPrint('initState 다른작업 5');
  }

  Future<void> _loadData() async {
    debugPrint('_loadData');
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      debugPrint('setState');
      _data = '데이터를 불러왔습니다.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Future 예제')),
      body: Center(child: Text('비동기 함수 실습')),
    );
  }
}
