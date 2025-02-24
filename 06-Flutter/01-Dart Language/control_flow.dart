void main() {
  // if-else
  int age = 20;
  if (age >= 19) {
    print('성인입니다.');
  } else {
    print('미성년자입니다.');
  }
  // for loop
  for (int i = 0; i < 5; i++) {
    print('현재 i의 값: $i');
  }

  // while loop
  int count = 0;
  while (count < 5) {
    print('현재 count의 값: $count');
    count++;
  }

  // switch-case
  String grade = 'A';
  switch (grade) {
    case 'A':
      print('최우수입니다.');
      break;
    case 'B':
      print('우수입니다.');
      break;
    case 'C':
      print('보통입니다.');
      break;
    default:
      print('기타');
  }
}
