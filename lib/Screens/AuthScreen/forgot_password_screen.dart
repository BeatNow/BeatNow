import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../../Controllers/auth_controller.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>(); // Obtener instancia del controlador AuthController
  final TextEditingController _emailController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF3C0F4B),
      minimumSize: Size(double.infinity, 56),
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: TextStyle(
        fontFamily: 'Franklin Gothic Demi',
        fontSize: 16.0,
      ),
    );
 
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinea los elementos al principio
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'Enter your email',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontFamily: 'Franklin Gothic Demi',
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _emailController,
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
            Center(
              child: Text(
                'An email will be sent to your account.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14.0,
                  fontFamily: 'Franklin Gothic Demi',
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Get the email from the text field
                String email = _emailController.text.trim();
                if (validator.email(email)) { // Verificar si el correo electrónico es válido
                  // Eliminar el símbolo "@" del correo electrónico antes de enviarlo a la API
 
                  // Save the email to AuthController
                  _authController.email.value = email;
                  // Change tab to 11
                  _authController.changeTab(11);
                } else {
                  // Mostrar un mensaje de error si el correo electrónico no es válido
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid email address.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF3C0F4B),
                    ),
                  );
                }
              },
              style: buttonStyle,
              child: Text('Send'),
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
                        _authController.changeTab(9);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
