// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/widgets/back_handler_button.dart';
import 'package:food_picker/common/widgets/common_button.dart';
import 'package:food_picker/common/widgets/common_input_field.dart';
import 'package:food_picker/common/widgets/common_text.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  /// Text InputField Controller 객체 생성
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  /// 뒤로가기 처리
  BackHandlerButton? backHandlerButton;

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

  /// 소프트 키보드 비활성화
  void _keyboardDismiss() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    backHandlerButton = BackHandlerButton(context: context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      print('앱이 포그라운드에서 실행중입니다.');
    } else {
      print('앱이 백그라운드에서 실행중입니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (backHandlerButton != null) {
          return backHandlerButton!.onWillPop();
        }

        return Future.value(false);
      },
      child: GestureDetector(
        onTap: _keyboardDismiss,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(Sizes.size24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v120,
                  const Center(
                    child: Text(
                      '푸드피커',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size52,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gaps.v52,

                  /// Email Address Input
                  Container(
                    margin: const EdgeInsets.only(bottom: Sizes.size28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          textContent: '이메일주소',
                          textColor: Colors.grey.shade500,
                          textSize: Sizes.size22,
                        ),
                        InputField(
                          controller: _emailController,
                          readOnly: false,
                          obscureText: false,
                          maxLines: 1,
                          validator: (value) => _emailValidation(value),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        )
                      ],
                    ),
                  ),

                  /// Password Input
                  Container(
                    margin: const EdgeInsets.only(bottom: Sizes.size28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          textContent: '패스워드',
                          textColor: Colors.grey.shade500,
                          textSize: Sizes.size22,
                        ),
                        InputField(
                          controller: _pwdController,
                          readOnly: false,
                          obscureText: true,
                          maxLines: 1,
                          validator: (value) => _pwdValidation(value),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    ),
                  ),

                  /// Login Process
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.size58,
                    margin: const EdgeInsets.only(
                      bottom: Sizes.size22,
                      top: Sizes.size48,
                    ),
                    child: CommonButton(
                      btnText: '로그인',
                      btnBackgroundColor: Colors.black,
                      textColor: Colors.white,
                      btnAction: () {
                        print('로그인 로직 처리!');
                      },
                    ),
                  ),

                  /// Navigate to SignUp Screen
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.size58,
                    margin: const EdgeInsets.only(bottom: Sizes.size22),
                    child: CommonButton(
                      btnText: '회원 가입',
                      btnBackgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      btnAction: () async {
                        await Navigator.pushNamed(
                          context,
                          SignUpScreen.routeName,
                        );
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
