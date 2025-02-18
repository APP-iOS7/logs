// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_demo/main.dart';

void main() {
  group('Login Test Group', () {
    testWidgets('exist widget check', (WidgetTester testWorker) async {
      // Arrange
      final testUsername = find.byKey(const ValueKey('testUsername'));
      final testPassword = find.byKey(const ValueKey('testPassword'));
      final testLoginButton = find.byKey(const ValueKey('testLoginButton'));

      // Act
      // 화면에 위젯을 그린다.
      await testWorker.pumpWidget(const MyApp());

      // Assert
      // 화면에 TextField 위젯이 있는지 확인한다.
      expect(testUsername, findsOneWidget);
      expect(testPassword, findsOneWidget);
      expect(testLoginButton, findsOneWidget);
    });

    testWidgets('should allow login', (WidgetTester testWorker) async {
      // Arrange
      final testUsername = find.byKey(const ValueKey('testUsername'));
      final testPassword = find.byKey(const ValueKey('testPassword'));
      final testLoginButton = find.byKey(const ValueKey('testLoginButton'));

      // Act
      // 화면에 위젯을 그린다.
      await testWorker.pumpWidget(const MyApp());
      // 화면에 TextField 위젯을 찾아서 입력값을 넣는다.
      await testWorker.enterText(testUsername, 'username');
      await testWorker.enterText(testPassword, 'password');

      // 화면에 ElevatedButton 위젯을 찾아서 클릭한다.
      await testWorker.tap(testLoginButton);

      // 화면을 다시 그린다.
      await testWorker.pump();

      // Assert
      // 화면에 SnackBar 위젯이 있는지 확인한다.
      expect(find.text('Logging in...'), findsOneWidget);
    });
  });
}
