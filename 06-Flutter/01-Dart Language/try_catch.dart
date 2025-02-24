void main() {
  // try-catch
  try {
    int result = 10 ~/ 0;
    print('결과: $result');
  } catch (e) {
    print('에러 발생: $e');
  }

  // try-catch-finally
  try {
    // file open
    // process
    int result = 10 ~/ 0;
    print('결과: $result');
  } catch (e) {
    // error handling
    print('에러 발생: $e');
  } finally {
    // file close
    print('작업 완료');
  }

  // try-catch-on
  try {
    // 여러 종류의 에러가 발생할 수 있는 코드
    // dynamic value = "123";  // TypeError를 피하기 위해 주석처리.
    // dynamic value = "abc";
    // int number = int.parse(value); // FormatException 발생 가능
    // print(number);
    int number = 4;
    List<int> list = [1, 2, 3];
    print(list[number]); // RangeError 발생 가능 (number가 3보다 크면)
  } on FormatException catch (e) {
    print("FormatException 처리: $e");
  } on RangeError catch (e) {
    print("RangeError 처리: $e");
  } on TypeError catch (e) {
    //dynamic 사용시 타입체크가 런타임에 일어나므로, TypeError도 여기서 잡힘
    print("TypeError 처리: $e");
  } catch (e) {
    print("그 외 다른 에러 처리: $e"); // 위의 catch 블록에서 처리되지 않은 모든 에러
  }
}
