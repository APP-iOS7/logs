class Person {
  // 필드
  String name;
  int age;

  // 생성자
  Person(this.name, this.age);

  // 메서드
  void introduce() {
    print('My name is $name. I am $age years old.');
  }

  // Getter
  String get getName => name;

  // Setter
  set personAge(int value) {
    if (value >= 0) {
      age = value;
    }
  }
}

void main() {
  // 인스턴스 생성
  var person = Person('John Doe', 30);

  // 필드 접근
  print('Name: ${person.name}, Age: ${person.age}');

  // 메서드 호출
  person.introduce();

  // Getter 호출
  print('Getter: ${person.getName}');

  // Setter 호출
  person.personAge = 40;
  print('Setter: ${person.age}');
}
