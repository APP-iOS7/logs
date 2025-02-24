Future<String> fetchData() async {
  // 2초 지연 시뮬레이션
  await Future.delayed(Duration(seconds: 2));
  return 'Data fetched successfully';
}

Future<void> processData() async {
  print('데이터 요청 시작...');
  try {
    String result = await fetchData();
    print('결과: $result');
  } catch (e) {
    print('에러 발생: $e');
  }
  print('데이터 요청 종료');
}

void main() async {
  await processData();
}
