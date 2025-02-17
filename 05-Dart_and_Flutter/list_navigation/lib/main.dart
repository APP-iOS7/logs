import 'package:flutter/material.dart';

import 'navigator2_demo.dart';

void main() {
  runApp(const MyApp());
}

class Routes {
  static const String home = '/';
  static const String signUp = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case signUp:
        return MaterialPageRoute(builder: (context) => const SignUpPage());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
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
        initialRoute: Routes.home,
        // onGenerateRoute 속성을 사용하여 경로를 생성
        onGenerateRoute: Routes.generateRoute);
  }
}
