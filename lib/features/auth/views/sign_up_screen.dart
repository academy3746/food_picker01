// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/app_snackbar.dart';
import 'package:food_picker/common/utils/common_app_bar.dart';
import 'package:food_picker/common/utils/common_button.dart';
import 'package:food_picker/common/utils/common_input_field.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/common/utils/image_uploader.dart';
import 'package:food_picker/data/model/member.dart';
import 'package:food_picker/features/auth/widgets/profile.dart';
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

  /// 파일 업로드 기능 수행
  late ImageUploader uploader;

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

  @override
  void initState() {
    super.initState();

    uploader = ImageUploader(
      context: context,
      imgFile: profileImg,
      onImageUploaded: _onImageUploaded,
    );
  }

  /// ImageUploader 콜백 동작 별도 처리
  void _onImageUploaded(File? file) {
    setState(() {
      profileImg = file;
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
                    onTap: () async {
                      uploader.showImageUploadBottomSheet();
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

                        /// Check Validation
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        /// CRUD on Supabase Server
                        bool success = await _registerAccount(
                          emailValue,
                          pwdValue,
                        );

                        if (!context.mounted) return;

                        if (!success) {
                          var snackBar = AppSnackbar(
                            context: context,
                            msg: '회원 가입이 정상적으로 처리 되지 않았습니다!',
                          );

                          snackBar.showSnackbar(context);

                          return;
                        } else {
                          var snackBar = AppSnackbar(
                            context: context,
                            msg: '환영 합니다! 같이 새로운 맛집을 찾아 볼까요?',
                          );

                          snackBar.showSnackbar(context);

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
