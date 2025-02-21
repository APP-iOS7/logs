import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _updateProfileImage() async {
    try {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) {
        return;
      }

      // 파일 업로드
      final File file = File(pickedImage.path);
      final ref = FirebaseStorage.instance.ref(
        'profile_images/${FirebaseAuth.instance.currentUser!.uid}',
      );
      await ref.putFile(file);

      // 다운로드 URL 업데이트
      final String downloadUrl = await ref.getDownloadURL();

      // 사용자 프로필 업데이트
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint('프로필 사진 변경 실패: $e');
    }
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
              onPressed: _updateProfileImage,
              child: const Text('프로필 사진 변경'),
            ),
          ],
        ),
      ),
    );
  }
}
