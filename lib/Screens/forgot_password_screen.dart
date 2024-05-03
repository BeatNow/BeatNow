import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../Controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
    final AuthController _authController = Get.find<AuthController>(); // Obtener instancia del controlador AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Color(0xFF111111),
        elevation: 0,
        title: Text(
          'Forgot Password?',
          style: TextStyle(
            fontFamily: 'Franklin Gothic Demi',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
          children: <Widget>[
            Text(
              'Enter your email',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
                fontFamily: 'Franklin Gothic Demi',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF494949),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8.0),
            Text(
              'An email will be sent to your account.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14.0,
                fontFamily: 'Franklin Gothic Demi',
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement send password reset email logic
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Send Recuperation Email',
                style: TextStyle(
                  fontFamily: 'Franklin Gothic Demi',
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Go to ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF4E0566),
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        _authController.changeTab(0);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
