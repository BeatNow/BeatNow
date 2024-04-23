import 'dart:convert';
import 'package:BeatNow/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'auth_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>(); // Obtener instancia del controlador AuthController
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
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Cambiar el estado de _obscurePassword para alternar entre mostrar u ocultar la contraseña
                            _togglePasswordVisibility();
                          },
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
                    //_authController.changeTab(3);
                    _login(_usernameController.text, _passwordController.text, context);
                  },
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

  void _togglePasswordVisibility() {
    // Cambiar el estado de _obscurePassword para alternar entre mostrar u ocultar la contraseña
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }


  void _login(String username, String password, BuildContext context) async {
    // Verificar si los campos de nombre de usuario y contraseña no están vacíos
    if (username.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Username and password are required.', context);
      return;
    }

    try {
      // Llamar a la función para iniciar sesión
      final Map<String, dynamic> response = await loginUser(username, password);
      
      // Manejar la respuesta del servidor
      if (response.containsKey('message')) {
        // Si la respuesta contiene la clave 'message', el inicio de sesión fue exitoso
        _showErrorSnackBar('Login successful!', context);
        // Aquí puedes manejar la lógica para redirigir al usuario a otra pantalla o realizar otras acciones necesarias después del inicio de sesión exitoso
        _authController.changeTab(3);
      } else {
        // Si la respuesta no contiene 'message', mostrar un mensaje de error basado en el detalle proporcionado por el servidor
        _showErrorSnackBar(response['detail'], context);
      }
    } catch (e) {
      // Capturar cualquier excepción que pueda ocurrir durante el proceso de inicio de sesión
      _showErrorSnackBar('Failed to login: $e', context);
    }
  }

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    Uri apiUrl = Uri.parse('http://217.182.70.161:6969/login');

    Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

    final http.Response response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    // Decodificar y devolver la respuesta del servidor
    return json.decode(response.body);
  }


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

Future<void> getUserInfo() async {
  try {
    // Define the API URL
    final apiUrl = Uri.parse('http://217.182.70.161:8001/v1/api/users/users/me');
    // Fetch user information from the API
    final response = await http.get(apiUrl);

    // Check if the response status code is 200 (success)
    if (response.statusCode == 200) {
      // Decode the response body from JSON
      final userData = json.decode(response.body);

      // Process the user data
      processUserData(userData);
    } else {
      // If the response status code is not 200, throw an exception
      throw Exception('Failed to fetch user information. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Catch any errors that occur during the process
    print('Error fetching user information: $error');
  }
}

void processUserData(Map<String, dynamic> userData) {
  // Add your logic to process the user data here
  UserSingleton().name = userData['name'];
  UserSingleton().username = userData['username'];
  UserSingleton().email = userData['email'];
}
}
