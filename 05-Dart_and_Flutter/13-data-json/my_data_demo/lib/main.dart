import 'dart:convert';

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
  late Future<List<String>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = _loadMonths();
  }

  Future<List<String>> _loadMonths() async {
    String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/example.json');
    // json 파싱된 결과를 List<String>으로 변환
    return jsonDecode(jsonString).values.cast<String>().toList();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('My Data App')),
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
