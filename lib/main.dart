import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'forgot_password_screen.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profileuser_screen.dart';
import 'home_screen.dart';// Import ProfileScreen

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'Franklin Gothic Demi',
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (_authController.selectedIndex.value) {
        case 0:
          return LoginScreen();
        case 1:
          return SignUpScreen();
        case 2:
          return ForgotPasswordScreen();
        case 3:
          return HomeScreenState();
        case 4:
          return ProfileScreen(); // Add this case
        default:
          return LoginScreen();
      }
    });
  }
}
