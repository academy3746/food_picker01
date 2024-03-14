// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_picker/features/auth/views/login_screen.dart';
import 'package:food_picker/features/auth/views/sign_up_screen.dart';
import 'package:food_picker/features/post/models/food_store.dart';
import 'package:food_picker/features/post/views/detail_screen.dart';
import 'package:food_picker/features/main/views/main_screen.dart';
import 'package:food_picker/features/post/views/edit_screen.dart';
import 'package:food_picker/features/post/views/post_webview_screen.dart';
import 'package:food_picker/features/splash/views/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String url = 'https://bvfrgnkyxgtdfrgxmrol.supabase.co';

  const String key =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2ZnJnbmt5eGd0ZGZyZ3htcm9sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkzNjg0NzMsImV4cCI6MjAyNDk0NDQ3M30.SYPWJrTJDDquFfZCdS8X4L0iN-q3fsKB_vdWBEIPvyo';

  const String naverClientId = '0ldmdl71hs';

  /// Initialize Supabase
  await Supabase.initialize(
    url: url,
    anonKey: key,
  );

  /// Initialize Naver Map SDK
  await NaverMapSdk.instance.initialize(
    clientId: naverClientId,
    onAuthFailed: (error) => print('${error.code}: ${error.message}'),
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

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
        EditScreen.routeName: (context) => const EditScreen(),
        WebViewScreen.routeName: (context) => const WebViewScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == DetailScreen.routeName) {
          FoodStoreModel foodStoreModel = settings.arguments as FoodStoreModel;

          return MaterialPageRoute(
            builder: (context) {
              return DetailScreen(model: foodStoreModel);
            },
          );
        }
        return null;
      },
    );
  }
}
