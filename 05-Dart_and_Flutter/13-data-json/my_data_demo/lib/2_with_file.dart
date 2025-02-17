// plain text 파일을 읽어와서 문자열 데이터를 List<String>으로 변환하여 화면에 출력
// assets/example.ext 파일을 만들고, 그 파일을 읽어와서 화면에 출력
// pubspec.yaml 파일에 assets 설정을 추가
// assets:
//   - assets/example.txt
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<String>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = _loadMonths();
  }

  Future<List<String>> _loadMonths() async {
    String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/example.txt');
    // json 파싱된 결과를 List<String>으로 변환
    return jsonString.split(',');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '파일로 데이터 가져오기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('파일로 데이터 가져오기')),
        body: FutureBuilder<List<String>>(
          future: futureData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // 미래 데이터에 대해 값이 없는 경우 (1: 값이 안넘어온 경우, 2: 로딩 중, 3: 에러)
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(data[index]));
              },
            );
          },
        ),
      ),
    );
  }
}
