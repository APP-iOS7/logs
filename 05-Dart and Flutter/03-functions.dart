void main() {
  // main function
  // 실습: 함수 선언 및 호출

  // 함수 호출
  getCurrentDateTime();

  var hourDifference = -7;
  getCurrentDateTimeWithDifference(hourDifference);

  // 파라미터 생략 가능한 함수 호출
  printGreetingNamed();
  printGreetingNamed(personName: "Rich");
  printGreetingNamed(personName: "Mary", clientId: 001);

  // 실습: 반환 값이 있는 함수
  DateTime timeNow = getTimeDifference(0);
  DateTime timeDifference = getTimeDifference(-7);

  print('Current time: $timeNow');
  print('Time with Difference: $timeDifference');
}

// 함수 선언: 반환 값이 있는 함수
DateTime getTimeDifference(int hourDifference) {
  DateTime timeNow = DateTime.now();
  DateTime timeDifference = timeNow.add(Duration(hours: hourDifference));

  return timeDifference;
}

// 이름이 있는 파라미터 함수 선언, 기본값 설정
void printGreetingNamed({String personName = 'Stranger', int clientId = 999}) {
  if (personName.contains('Stranger')) {
    print('Employee: $clientId, Stranger danger!');
  } else {
    print('Employee: $clientId, Hello $personName');
  }
}

// 함수 선언
void getCurrentDateTime() {
  // 현재 시간을 가져오는 함수
  var currentTime = DateTime.now();
  print('Current time: $currentTime');
}

// 파라미터가 있는 함수 선언
void getCurrentDateTimeWithDifference(int hourDifference) {
  // 현재 시간을 가져오는 함수
  var timeNow = DateTime.now();
  // 시간 차이를 계산
  var timeDifference = timeNow.add(Duration(hours: hourDifference));

  print('Current time: $timeNow');
  print('Time with Difference: $timeDifference');
}
