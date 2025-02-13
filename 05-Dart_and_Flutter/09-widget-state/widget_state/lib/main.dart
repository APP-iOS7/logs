import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// 메인 함수
void main() {
  // runApp 함수를 호출하여 MyApp 위젯을 실행
  runApp(const MyApp());
}

class PlatformCheck extends StatelessWidget {
  const PlatformCheck({Key? key}) : super(key: key);

  bool get isWeb => kIsWeb;
  bool get isMobileDevice => Platform.isAndroid || Platform.isIOS;
  bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  bool get isMobileDeviceOrWeb => isMobileDevice || isWeb;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Text('Running on the web!');
    } else if (Platform.isAndroid) {
      return const Text('Running on Android!');
    } else if (Platform.isIOS) {
      return const Text('Running on iOS!');
    } else {
      return const Text('Running on Fuchsia!');
    }
  }
}

// MyApp 위젯: StatelessWidget 상태관리가 필요하지 않은 단순한 형태의 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Fonts Demo',
      debugShowCheckedModeBanner: false,
      // 테마 설정
      theme: ThemeData(
          // 기본 색상 스키마 설정
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyLarge:
                GoogleFonts.aBeeZee(fontSize: 30, color: Colors.deepOrange),
            bodyMedium:
                GoogleFonts.aBeeZee(fontSize: 18, color: Colors.grey[700]),
          )),
      // 홈 페이지 설정
      // 타이틀 파라미터 전달
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// MyHomePage 위젯: StatefulWidget 상태관리가 필요한 위젯
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // title 변수: 홈페이지의 타이틀을 저장하는 런타임 상수
  final String title;

  // createState 함수를 호출하여 MyHomePageState 객체를 생성
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// MyHomePageState 클래스: MyHomePage 위젯의 상태를 관리하는 클래스
class _MyHomePageState extends State<MyHomePage> {
  // build 함수: 위젯을 생성하는 함수
  @override
  Widget build(BuildContext context) {
    // Scaffold 위젯: 머테리얼 디자인의 기본 레이아웃 구조를 제공
    return Scaffold(
      backgroundColor: Colors.grey,
      // body 속성에 Center 위젯을 사용하여 화면 중앙에 컨텐츠를 배치
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PlatformCheck 위젯을 생성하여 화면에 표시
          PlatformCheck(),
          _buildContainer(context),
        ],
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    // kIsWeb 변수를 사용하여 현재 플랫폼이 웹인지 확인
    if (kIsWeb) {
      return _buildWideContainers();
      // Platform 클래스는 현재 플랫폼을 확인하는 기능을 제공
    } else if (Platform.isAndroid) {
      return _buildWideContainers();
    } else if (Platform.isIOS) {
      return _buildNarrowContainers();
    } else {
      return _buildNarrowContainers();
    }
  }

  Widget _buildWideContainers() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'Red',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.green,
            child: Center(
              child: Text(
                'Green',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blue,
            child: Center(
              child: Text(
                'Blue',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowContainers() {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 100,
          child: Center(
            child: Text(
              'Red',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Container(
          color: Colors.green,
          height: 100,
          child: Center(
            child: Text(
              'Green',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          height: 100,
          child: Center(
            child: Text(
              'Blue',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
