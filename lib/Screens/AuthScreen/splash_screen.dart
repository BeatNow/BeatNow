import 'package:BeatNow/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 
class SplashScreen extends StatelessWidget {
  final int param;
  final AuthController _authController = Get.put(AuthController());
 
 
  SplashScreen(int i) : param = i;
 
  @override
  Widget build(BuildContext context) {
    if (param == 0) {
      _authController.checkLogin();
    }else if (param == 2) {
      _authController.sendPasswordMail(_authController.email.value);
    }
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      ),
    );
  }
}