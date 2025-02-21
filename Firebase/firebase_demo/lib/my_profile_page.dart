import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage:
                  _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              minWidth: 160,
              onPressed: () {},
              child: const Text('프로필 사진 변경'),
            ),
          ],
        ),
      ),
    );
  }
}
