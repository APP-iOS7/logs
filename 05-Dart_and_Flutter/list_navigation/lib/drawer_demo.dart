import 'package:flutter/material.dart';

class DrawerDemo extends StatelessWidget {
  const DrawerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Drawer Demo'),
        ),
        body: Center(
          child: Text('Drawer Demo'),
        ),
        // scaffold 위젯에 drawer 속성 추가하면 드로어 위젯이 화면에 표시됨, 햄버거 메뉴 아이콘을 누르면 드로어 위젯이 나타남
        drawer: MyDrawerWidget());
  }
}

// 드로어 위젯: 페이지 이동을 위한 메뉴 위젯
class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        // 드로워 메뉴 헤더
        DrawerHeader(
            child: InkWell(
                child: Icon(Icons.home, size: 35),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => DrawerDemo()));
                })),
        // 드로워 메뉴 아이템
        ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Drawer Item #1'),
            onTap: () {
              // pushReplacement 메서드를 사용하면 현재 화면을 교체하면서 새로운 화면으로 이동
              Navigator.of(context).pushReplacement(
                  // MaterialPageRoute 위젯을 사용하여 새로운 화면으로 이동
                  MaterialPageRoute(builder: (context) => DemoPageOne()));
            }),
        ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Drawer Item #2'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DemoPageTwo()));
            }),
        ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Drawer Item #3'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DemoPageThree()));
            }),
      ],
    ));
  }
}

// 드로어 메뉴 아이템을 클릭하면 이동할 페이지 위젯
class DemoPageOne extends StatelessWidget {
  const DemoPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo Page One'),
        ),
        body: Center(
          child: Text('Demo Page One'),
        ),
        drawer: MyDrawerWidget());
  }
}

class DemoPageTwo extends StatelessWidget {
  const DemoPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo Page Two'),
        ),
        body: Center(
          child: Text('Demo Page Two'),
        ),
        drawer: MyDrawerWidget());
  }
}

class DemoPageThree extends StatelessWidget {
  const DemoPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo Page Three'),
        ),
        body: Center(
          child: Text('Demo Page Three'),
        ),
        drawer: MyDrawerWidget());
  }
}
