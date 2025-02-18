import 'dart:convert';

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age};
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(name: map['name'], age: map['age']);
  }
}

void main() {
  var user = User(name: '홍길동', age: 20);

  // Map을 JSON 문자열로 변환 => Serialize 직렬화
  String userJson = jsonEncode(user.toMap());
  print(userJson);

  // JSON 문자열을 Map으로 변환 => Deserialize 역 직렬화
  String jsonString = '{"name": "김철수", "age": 30}';

  Map<String, dynamic> userMap = jsonDecode(jsonString);
  print(userMap);

  var user2 = User.fromJson(userMap);
  print(user2.name);
  print(user2.age);
}
