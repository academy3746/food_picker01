import 'package:flutter/material.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/sign_up_screen.dart';
import 'package:food_picker/screens/main_screen/main_screen.dart';
import 'package:food_picker/screens/splash_screen/splash_screen.dart';
import 'screens/auth_screen/login_screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Picker',
      theme: ThemeData(
        primaryColor: const Color(0xFF82B1FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF82B1FF),
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
      },
    );
  }
}
