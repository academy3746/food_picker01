// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/widgets/back_handler_button.dart';
import 'package:food_picker/common/widgets/section_text.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  /// 뒤로가기 처리
  BackHandlerButton? backHandlerButton;

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'TEST VERSION',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: SectionText(
            textContent: 'DEMO APP',
            textColor: Colors.grey.shade400,
            textSize: Sizes.size20,
            textWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
