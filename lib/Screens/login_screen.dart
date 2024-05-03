import 'dart:convert';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Controllers/auth_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<
      AuthController>(); // Obtener instancia del controlador AuthController
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

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
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Franklin Gothic Demi'),
                ),
                Text(
                  'Please sign into your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF494949),
                      fontFamily: 'Franklin Gothic Demi'),
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
                  controller: _usernameController,
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Color(0xFF494949),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      controller: _passwordController,
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
                  onPressed: () {
                    // Navega a la pestaña HomeScreenState
                    _login(_usernameController.text, _passwordController.text,
                        context);
                  },
                  style: buttonStyle,
                ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.black),
                  label: Text('Sign in with Google',
                      style: TextStyle(color: Colors.black)),
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
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
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
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF4E0566)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _authController.changeTab(
                                1); // Acción para cambiar a la pestaña de registro
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login(String username, String password, BuildContext context) async {
  // Obtener el token de acceso
  final token = await _token(username, password, context);

  if (token != null) {
    // Obtener información del usuario usando el token
    final userInfo = await getUserInfo(token);

    if (userInfo != null) {
      // Navegar a la pestaña HomeScreenState
      _authController.changeTab(3);
    } else {
      // Mostrar mensaje de error si no se pudo obtener la información del usuario
      _showErrorSnackBar('Failed to get user info' , context);
    }
  } else {
    // Mostrar mensaje de error si no se pudo obtener el token de acceso
    _showErrorSnackBar('Failed to get access token' , context);
  }
}
  Future<Map<String, dynamic>> getTokenUser(String username, String password) async {
    final apiUrl = Uri.parse('http://217.182.70.161:6969/token');

    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    // Decodificar y devolver la respuesta del servidor
    return json.decode(response.body);
  }


Future<String?> _token(String username, String password, BuildContext context) async {
  final response = await getTokenUser(username, password);

  if (response["access_token"] != null) {
    // Actualizar el token de acceso en UserSingleton
    UserSingleton().token = response["access_token"];
    String token = response["access_token"];
    return token;
  } else {
    // Mostrar mensaje de error si la petición falla
    _showErrorSnackBar(response[""], context);
    return null;
  }
}

Future<Map<String, dynamic>?> getUserInfo(String token) async {
  final apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/users/me');

  try {
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.body.isNotEmpty) {
      final jsonResponse = jsonDecode(response.body);
      UserSingleton().name = jsonResponse['full_name'];
      UserSingleton().username = jsonResponse['username'];
      UserSingleton().email = jsonResponse['email'];
      return jsonResponse;
    }
    else if(response.statusCode == 401){
      // Mostrar mensaje de error si la solicitud falla
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
    else {
      // Mostrar mensaje de error si la solicitud falla
      print('Request failed with status: ${response.statusCode}.');
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    // Mostrar mensaje de error si se produce una excepción
    print('Error: $e');
    return null;
  }
}


  // Función para mostrar un SnackBar con un mensaje de error
  void _showErrorSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3C0F4B),
      ),
    );
  }
}
