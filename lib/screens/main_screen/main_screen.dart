// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_picker/common/widgets/back_handler_button.dart';
import 'package:food_picker/screens/home_screen/home_screen.dart';
import 'package:food_picker/screens/info_screen/info_screen.dart';
import 'package:food_picker/screens/like_screen/like_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  /// 뒤로가기 처리
  BackHandlerButton? backHandlerButton;

  /// Selected Index No.
  int screenIndex = 0;

  /// Widget Screens in MainScreen
  final List<Widget> _screens = [
    const HomeScreen(),
    const LikeScreen(),
    const InfoScreen(),
  ];

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
        body: _screens.elementAt(screenIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: screenIndex,
          backgroundColor: Theme.of(context).primaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black45,
          onTap: (index) {
            setState(() {
              screenIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.map),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
