void main() {
  // var 타입 추론하는 변수
  var name = 'John Doe';
  String explicitName = 'John';
  int age = 30;
  double height = 1.80;
  bool isMarried = false;

  print(name);
  print(explicitName);
  print(age);
  print(height);
  print(isMarried);

  // 컬렉션 타입 예제
  List<String> fruits = ['apple', 'banana', 'orange'];
  print(fruits);

  Map<String, int> scores = {
    'math': 90,
    'english': 80,
    'science': 70,
  }; // key-value pair
  print(scores);

  Set<int> numbers = {2, 3, 4, 1, 5};
  print(numbers);
  numbers.add(5);
  print(numbers);

  // Null safety
  String? nullableName;
  String nonNullableName = 'John';

  // ignore: dead_code
  print(nullableName?.length); // null
  print(nonNullableName.length);

  // String interpolation
  print('My name is $name, and I am $age years old.');
  print('My name is ${name.toUpperCase()}, and I am ${age + 5} years old.');
  print('Fruits: ${fruits.join(', ')}'); // apple, banana, orange
  print('Scores: ${scores['math']}'); // 90
  print('Unique numbers: $numbers'); // {2, 3, 4, 1, 5}
  print('Nullable name: ${nullableName ?? '이름 없음'}'); // 이름 없음
}
