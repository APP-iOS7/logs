import 'dart:convert';

import 'package:flutter/material.dart';

// JSON 데이터를 파싱하기 위한 클래스: DataItem - title을 가지고 있는 클래스
class DataItem {
  final String title;
  DataItem({required this.title});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(title: json['title']);
  }
}

// JSON 데이터를 파싱하기 위한 클래스: List<DataItem>을 가지고 있는 클래스
class DataSeries {
  final List<DataItem> dataModel;

  DataSeries({required this.dataModel});

  factory DataSeries.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DataItem> dataList =
        list.map((dataModel) => DataItem.fromJson(dataModel)).toList();
    return DataSeries(dataModel: dataList);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<DataSeries> dataSeries;

  @override
  void initState() {
    super.initState();
    dataSeries = fetchData();
  }

  Future<DataSeries> fetchData() async {
    String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/example2.json');
    DataSeries dataSeries = DataSeries.fromJson(jsonDecode(jsonString));
    return dataSeries;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '파일 데이터를 JSON으로 가져오기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('파일 데이터를 JSON으로 가져오기')),
        body: FutureBuilder<DataSeries>(
          future: dataSeries,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.dataModel.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(data.dataModel[index].title));
              },
            );
          },
        ),
      ),
    );
  }
}
