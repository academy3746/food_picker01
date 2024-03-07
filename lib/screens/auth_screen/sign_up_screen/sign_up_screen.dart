// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/widgets/common_app_bar.dart';
import 'package:food_picker/common/widgets/common_input_field.dart';
import 'package:food_picker/common/widgets/common_text.dart';
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
  File? profileImg;

  /// Input Field Controller 객체 생성
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _introController = TextEditingController();


  /// 프로필 등록 Bottom Sheet Dialog
  Future<void> _showProfileUpload() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            top: Sizes.size10,
            bottom: Sizes.size10,
          ),
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
                onPressed: () async {
                  Navigator.pop(context);

                  await _getGalleryImage();
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
                onPressed: () async {
                  Navigator.pop(context);

                  await _deleteImage();
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
      imageQuality: 10,
    );

    if (image != null) {
      setState(() {
        profileImg = File(image.path);
      });
    }
  }

  /// 갤러리에서 사진 선택
  Future<void> _getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (image != null) {
      setState(() {
        profileImg = File(image.path);
      });
    }
  }

  /// 프로필 삭제
  Future<void> _deleteImage() async {
    setState(() {
      profileImg = null;
    });
  }

  /// 소프트 키보드 비활성화
  void _keyboardDismiss() {
    FocusScope.of(context).unfocus();
  }
  
  /// 닉네임 검증
  dynamic _nameValidation(value) {
    if (value.isEmpty) {
      return '닉네임을 입력해 주세요!';
    }

    return null;
  }
  
  /// 이메일 검증
  dynamic _emailValidation(value) {
    if (value.isEmpty) {
      return '이메일을 입력해 주세요!';
    }

    return null;
  }
  
  /// 패스워드 검증
  dynamic _pwdValidation(value) {
    if (value.isEmpty) {
      return '패스워드를 입력해 주세요!';
    }

    return null;
  }
  
  /// 패스워드 확인 검증
  dynamic _confirmValidation(value) {
    if (value.isEmpty) {
      return '패스워드 재확인 필드를 입력해 주세요!';
    }

    return null;
  }
  
  /// 자기소개 검증 (?)
  dynamic _introValidation(value) {
    if (value.isEmpty) {
      return '자기소개를 입력해 주세요!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: '푸드피커 가입하기',
        isLeading: true,
      ),
      body: GestureDetector(
        onTap: _keyboardDismiss,
        child: Container(
          margin: const EdgeInsets.all(Sizes.size20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile IMG
                GestureDetector(
                  onTap: () {
                    _showProfileUpload();
                  },
                  child: BuildProfile(profileImg: profileImg),
                ),
                Gaps.v32,

                /// Nickname
                Container(
                  margin: const EdgeInsets.only(top: Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: '닉네임',
                        textSize: Sizes.size20,
                        textColor: Colors.grey.shade500,
                        textWeight: FontWeight.w700,
                      ),
                      InputField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        readOnly: false,
                        onTap: null,
                        hintText: '닉네임을 입력해 주세요',
                        obscureText: false,
                        maxLines: 1,
                        maxLength: 15,
                        validator: (value) => _nameValidation(value),
                      ),
                    ],
                  ),
                ),

                /// E-mail Addr.
                Container(
                  margin: const EdgeInsets.only(top: Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: '이메일',
                        textSize: Sizes.size20,
                        textColor: Colors.grey.shade500,
                        textWeight: FontWeight.w700,
                      ),
                      InputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        readOnly: false,
                        onTap: null,
                        hintText: '이메일 주소를 입력해 주세요',
                        obscureText: false,
                        maxLines: 1,
                        maxLength: 50,
                        validator: (value) => _emailValidation(value),
                      ),
                    ],
                  ),
                ),

                /// Password
                Container(
                  margin: const EdgeInsets.only(top: Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: '패스워드',
                        textSize: Sizes.size20,
                        textColor: Colors.grey.shade500,
                        textWeight: FontWeight.w700,
                      ),
                      InputField(
                        controller: _pwdController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        readOnly: false,
                        onTap: null,
                        hintText: '패스워드를 입력해 주세요',
                        obscureText: true,
                        maxLines: 1,
                        maxLength: 25,
                        validator: (value) => _pwdValidation(value),
                      ),
                    ],
                  ),
                ),

                /// Confirm PWD
                Container(
                  margin: const EdgeInsets.only(top: Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: '패스워드 확인',
                        textSize: Sizes.size20,
                        textColor: Colors.grey.shade500,
                        textWeight: FontWeight.w700,
                      ),
                      InputField(
                        controller: _confirmController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        readOnly: false,
                        onTap: null,
                        hintText: '패스워드를 다시 한 번 입력해 주세요',
                        obscureText: true,
                        maxLines: 1,
                        maxLength: 25,
                        validator: (value) => _confirmValidation(value),
                      ),
                    ],
                  ),
                ),

                /// Introduce
                Container(
                  margin: const EdgeInsets.only(top: Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        textContent: '자기소개',
                        textSize: Sizes.size20,
                        textColor: Colors.grey.shade500,
                        textWeight: FontWeight.w700,
                      ),
                      InputField(
                        controller: _introController,
                        textInputAction: TextInputAction.newline,
                        enabled: true,
                        readOnly: false,
                        onTap: null,
                        hintText: '멋진 자기소개를 입력해 볼까요?',
                        maxLines: 5,
                        maxLength: 500,
                        obscureText: false,
                        validator: (value) => _introValidation(value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
