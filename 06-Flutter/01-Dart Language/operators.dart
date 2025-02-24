void main() {
  // 산술 연산자
  int a = 10;
  int b = 5;

  // 산술 연산의 기본 예제
  print('덧셈: ${a + b}'); // 15
  print('뺄셈: ${a - b}'); // 5
  print('곱셈: ${a * b}'); // 50
  print('나눗셈: ${a / b}'); // 2.0 (정수 나누기 정수는 double로 반환)
  print('나머지: ${a % b}'); // 0

  // 비교 연산자
  print('크다: a > b ${a > b}'); // true
  print('작다: a < b ${a < b}'); // false
  print('크거나 같다: a >= b ${a >= b}'); // true
  print('작거나 같다: a <= b ${a <= b}'); // false
  print('같다: a == b ${a == b}'); // false
  print('다르다: a != b ${a != b}'); // true

  // 논리 연산자
  bool x = true;
  bool y = false;
  print('AND: x && y ${x && y}'); // false
  print('OR: x || y ${!x || y}'); // true
  // ignore: dead_code
  print('NOT: !x ${!(x || y)} == ${!x && !y}'); // false
  print('NOT: !y ${!(x && y)} == ${!x || !y}'); // true

  // Null 병합 연산자 (??)
  String? nullableName;
  print('기본값: ${nullableName ?? '이름 없음'}'); // 이름 없음

  // 캐스케이드 연산자 (..)
  List<String> fruits = [];
  fruits
    ..add('apple') // fruits.add('apple')
    ..add('banana') // fruits.add('banana)
    ..add('orange'); // fruits.add('orange')

  var person =
      Person()
        ..name = 'John Doe'
        ..age = 30
        ..height = 1.80
        ..isMarried = false;

  person.printInfo();
}

class Person {
  String name = '';
  int age = 0;
  double height = 0.0;
  bool isMarried = false;

  void printInfo() {
    print('Name: $name, Age: $age, Height: $height, Married: $isMarried');
  }
}
