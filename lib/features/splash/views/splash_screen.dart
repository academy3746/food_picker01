import 'package:flutter/material.dart';
import 'package:food_picker/common/constants/gaps.dart';
import 'package:food_picker/common/constants/sizes.dart';
import 'package:food_picker/common/utils/common_text.dart';
import 'package:food_picker/features/auth/views/login_screen.dart';
import 'package:food_picker/features/main/views/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Supabase 객체 생성
  final _supabase = Supabase.instance.client;
  
  @override
  void initState() {
    super.initState();

    _navigateProcess();
  }
  
  Future<void> _navigateProcess() async {
    final login = _supabase.auth.currentUser;

    if (login == null) {
      Future.delayed(const Duration(seconds: 3), () async {
        await Navigator.pushReplacementNamed(
          context,
          LoginScreen.routeName,
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () async {
        await Navigator.pushReplacementNamed(
          context,
          MainScreen.routeName,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(
          Sizes.size20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                width: Sizes.size150 + Sizes.size30,
                height: Sizes.size150 + Sizes.size30,
              ),
              Gaps.v32,
              const CommonText(
                textContent: '푸드피커',
                textColor: Colors.black,
                textSize: Sizes.size36,
                textWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
