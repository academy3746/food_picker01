import 'package:flutter/material.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: const Text(
            '디버깅!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
