import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Login Test Group', () {
    FlutterDriver? driver;

    // 테스트 준비 작업: Arrange
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // 테스트 종료 작업
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });

    test('exist widget check', () async {
      final testUsername = find.byValueKey('testUsername');
      final testPassword = find.byValueKey('testPassword');
      final testLoginButton = find.byValueKey('testLoginButton');

      // textfield 가 존재하는지 확인
      await driver!.waitFor(testUsername);
      await driver!.waitFor(testPassword);
      await driver!.waitFor(testLoginButton);
    });

    test('should allow login', () async {
      final testUsername = find.byValueKey('testUsername');
      final testPassword = find.byValueKey('testPassword');
      final testLoginButton = find.byValueKey('testLoginButton');

      await driver!.tap(testUsername);
      await driver!.enterText('username');
      await driver!.tap(testPassword);
      await driver!.enterText('password');
      await driver!.tap(testLoginButton);

      await driver!.waitFor(find.text('Logging in...'));
    });
  });
}
