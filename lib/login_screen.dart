import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart'; // Necesario para TapGestureRecognizer

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>(); // Obtener instancia del controlador AuthController

  @override
  Widget build(BuildContext context) {
    
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      
      onPrimary: Colors.white,
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Franklin Gothic Demi'),
                ),
                Text(
                  'Please sign into your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF494949), fontFamily: 'Franklin Gothic Demi'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF494949),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Color(0xFF494949),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          // Añade la funcionalidad de olvidar contraseña aquí
                          // Acción para cambiar a la pestaña de registro
                        _authController.changeTab(2);

                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Franklin Gothic Demi',
                          ),
                        ),
                        
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
                ElevatedButton(
                  child: Text('Sign In'),
                  onPressed: () {},
                  style: buttonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.black),
                  label: Text('Sign in with Google', style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  style: buttonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
                  label: Text('Sign in with Facebook'),
                  onPressed: () {},
                  style: buttonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  ),
                ),
                SizedBox(height: 40.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF4E0566)),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          _authController.changeTab(1); // Acción para cambiar a la pestaña de registro
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
