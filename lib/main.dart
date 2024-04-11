import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_flutter/forgot_password_screen.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

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
      if (_authController.selectedIndex.value == 0) {
        return LoginScreen();
      } else if (_authController.selectedIndex.value == 1){
        return SignUpScreen();
      }
      else if (_authController.selectedIndex.value == 2){
        return ForgotPasswordScreen();
      }
      return LoginScreen();
    });
  }
}
