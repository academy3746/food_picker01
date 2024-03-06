// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/widgets/common_app_bar.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/widgets/profile.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// 프로필 이미지 객체 생성
  File? _profileImg;

  /// 프로필 등록 Bottom Sheet Dialog
  Future<void> _showProfileUpload() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await _takePhoto();
                },
                child: const Text(
                  '촬영하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('갤러리에서 사진 선택!');
                },
                child: const Text(
                  '갤러리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('프로필 이미지 삭제!');
                },
                child: const Text(
                  '프로필 삭제',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 사진 촬영
  Future<void> _takePhoto() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        _profileImg = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: '푸드피커 가입하기',
        isLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// profile_img
          GestureDetector(
            onTap: () {
              _showProfileUpload();
            },
            child: BuildProfile(profileImg: _profileImg),
          ),
        ],
      ),
    );
  }
}
