import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 디버그 모드일 때만 에뮬레이터 사용
  if (kDebugMode) {
    // Firebase Firestore Emulator 사용
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0),
          bodyMedium: TextStyle(fontSize: 15.0),
          bodySmall: TextStyle(fontSize: 10.0),
          labelLarge: TextStyle(fontSize: 20.0),
          labelMedium: TextStyle(fontSize: 15.0),
          labelSmall: TextStyle(fontSize: 10.0),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
      debugPrint('회원가입 성공: ${userCredential.user}');
    } catch (e) {
      debugPrint('회원가입 실패: ${e.toString()}');
    }
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
      debugPrint('로그인 성공: ${userCredential.user}');
    } catch (e) {
      debugPrint('로그인 실패: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Auth Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              minWidth: double.infinity,
              onPressed: _signIn,
              child: const Text('로그인'),
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              minWidth: double.infinity,
              onPressed: _signUp,
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
