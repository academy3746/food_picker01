import 'package:flutter/material.dart';
import 'package:food_picker/screens/auth_screen/sign_up_screen/sign_up_screen.dart';
import 'package:food_picker/screens/home_screen/home_screen.dart';
import 'package:food_picker/screens/info_screen/info_screen.dart';
import 'package:food_picker/screens/like_screen/like_screen.dart';
import 'package:food_picker/screens/main_screen/main_screen.dart';
import 'package:food_picker/screens/splash_screen/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen/login_screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String url = 'https://bvfrgnkyxgtdfrgxmrol.supabase.co';

  const String key =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2ZnJnbmt5eGd0ZGZyZ3htcm9sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkzNjg0NzMsImV4cCI6MjAyNDk0NDQ3M30.SYPWJrTJDDquFfZCdS8X4L0iN-q3fsKB_vdWBEIPvyo';

  /// Initialize Supabase
  await Supabase.initialize(
    url: url,
    anonKey: key,
  );

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
        HomeScreen.routeName: (context) => const HomeScreen(),
        LikeScreen.routeName: (context) => const LikeScreen(),
        InfoScreen.routeName: (context) => const InfoScreen(),
      },
    );
  }
}
