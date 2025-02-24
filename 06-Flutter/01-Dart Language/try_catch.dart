import 'dart:async';

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

  // catch 블록에서 조건문 사용 (덜 일반적, 복잡한 경우에 유용)
  try {
    dynamic value = "abc";
    int number = int.parse(value);
    print(number);
    List<int> list = [1, 2, 3];
    print(list[number]);
  } catch (e) {
    if (e is FormatException) {
      print("FormatException (조건문): $e");
    } else if (e is RangeError) {
      print("RangeError (조건문): $e");
    } else if (e is TypeError) {
      //dynamic 사용으로 인한 타입체크
      print("TypeError (조건문) : $e");
    } else {
      print("그 외 다른 에러 (조건문): $e");
    }
  }

  // Future에서 여러 에러 처리
  //   Future.wait을 사용할 때는, 개별 Future에 catchError를 붙여서 처리하는 것이 좋습니다.

  Future<int> future1 = Future.delayed(
    Duration(seconds: 1),
    () => int.parse("abc"),
  ); //FormatException
  Future<int> future2 = Future.delayed(Duration(seconds: 2), () => 10);
  Future<int> future3 = Future.delayed(
    Duration(seconds: 1),
    () => [1, 2, 3][5],
  ); //RangeError

  // Future.wait은 여러 Future를 동시에 실행하고, 모든 Future가 완료되면 결과를 반환합니다.
  Future.wait([
        future1.catchError((e) {
          print("future1 에러: $e");
          return -1; // 에러 발생 시 기본값 반환
        }),
        future2.catchError((e) {
          print("future2 에러 : $e");
          return -2;
        }),
        future3.catchError((e) {
          print("future3 에러: $e");
          return -3;
        }),
      ])
      .then((results) {
        print(
          "Future.wait 결과: $results",
        ); // [-1, 10, -3]  <- 에러가 발생한 future는 catchError에서 반환한 값으로 대체됨.
      })
      .catchError((e) {
        //Future.wait 자체에서 에러가 발생하면, 여기가 실행됨(거의 없음).
        print("Future.wait 자체 에러: $e");
      });

  // async/await 에서 여러 에러 처리
  processData()
      .then((value) => print("processData 완료"))
      .catchError((e) => print("processData에서 전역 에러 : $e"));
}

//async/await 를 사용한 에러처리
Future<void> processData() async {
  try {
    String data =
        await fetchData(); // TimeoutException, FormatException등 다양한 에러 발생 가능
    int number = int.parse(data);
    print(number);
  } on TimeoutException catch (e) {
    print("TimeoutException: $e");
  } on FormatException catch (e) {
    print("FormatException : $e");
  } catch (e) {
    print("알 수 없는 에러: $e");
    rethrow; //상위 호출자에게 에러를 다시 던짐.
  } finally {
    print("finally 블록 실행 (항상 실행됨)");
  }
}

Future<String> fetchData() async {
  // Future.delayed(
  //   Duration(seconds: 2),
  // ).timeout(Duration(milliseconds: 500)); //TimeoutException

  return Future.delayed(Duration(seconds: 2), () => "123"); //정상적인 경우
  //return Future.delayed(Duration(seconds: 2), () => "abc");  //FormatException
  
}
