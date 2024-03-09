// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/widgets/app_snackbar.dart';
import 'package:food_picker/common/widgets/common_app_bar.dart';
import 'package:food_picker/common/widgets/common_button.dart';
import 'package:food_picker/common/widgets/common_input_field.dart';
import 'package:food_picker/common/widgets/common_text.dart';
import 'package:food_picker/data/model/member.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/widgets/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// 프로필 이미지 객체 생성
  File? profileImg;

  /// 프로필 이미지 주소
  String? imageUrl;

  /// Input Field Controller 객체 생성
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _introController = TextEditingController();

  /// Validate Text Input Field
  final _formKey = GlobalKey<FormState>();

  /// Initialize Supabase Console
  final _supabase = Supabase.instance.client;

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

  /// 테이블에 회원 정보 등록
  Future<bool> _registerAccount(String emailValue, String pwdValue) async {
    var success = false;

    final AuthResponse response = await _supabase.auth.signUp(
      email: emailValue,
      password: pwdValue,
    );

    if (response.user != null) {
      success = true;

      if (profileImg != null) {
        var now = DateTime.now();

        var path = 'profiles/${response.user!.id}_$now.jpg';

        final imgFile = profileImg;

        await _supabase.storage.from('food_pick').upload(
              path,
              imgFile!,
              fileOptions: const FileOptions(upsert: true),
            );

        imageUrl = _supabase.storage.from('food_pick').getPublicUrl(path);
      }

      // 2. INSERT Database
      await _supabase.from('member').insert(
            MemberModel(
              name: _nameController.text,
              email: emailValue,
              introduce: _introController.text,
              uid: response.user!.id,
              profileUrl: imageUrl,
            ).toMap(),
          );
    } else {
      success = false;
    }

    return success;
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
            child: Form(
              key: _formKey,
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
                          hintText: '근사한 자기소개를 입력해 볼까요?',
                          maxLines: 5,
                          maxLength: 500,
                          obscureText: false,
                          validator: (value) => _introValidation(value),
                        ),
                      ],
                    ),
                  ),

                  /// 회원가입 완료
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.size64,
                    margin: const EdgeInsets.symmetric(vertical: Sizes.size32),
                    child: CommonButton(
                      btnBackgroundColor: Colors.black,
                      btnText: '가입 완료',
                      textColor: Colors.white,
                      btnAction: () async {
                        // 가입 완료 → 호출 변수
                        var emailValue = _emailController.text;
                        var pwdValue = _pwdController.text;

                        // Check Validation
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        // CRUD on Supabase Server
                        bool success = await _registerAccount(
                          emailValue,
                          pwdValue,
                        );

                        if (!context.mounted) return;

                        var snackBar = AppSnackbar(
                          context: context,
                          msg: '회원 가입이 정상적으로 처리 되지 않았습니다!',
                        );

                        if (!success) {
                          snackBar.showSnackbar(context);

                          return;
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
