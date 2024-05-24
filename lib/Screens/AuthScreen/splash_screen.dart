
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

      
    }

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Obx(() {

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            );         
          
        }),
      ),
    );
  }
}


