import 'package:flutter/material.dart';

import 'navigator2_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        // 홈 대신 initialRoute 속성을 사용하여 초기 경로를 지정
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const HomePage(),
          '/signup': (BuildContext context) => const SignUpPage(),
        });
  }
}
