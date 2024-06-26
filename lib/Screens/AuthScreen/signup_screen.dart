import 'dart:convert';
 
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 
 
import '../../Controllers/auth_controller.dart';
 
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Up Screen',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'Franklin Gothic Demi',
          ),
        ),
      ),
      home: SignUpScreen(),
    );
  }
}
 
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
 
class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.find<AuthController>(); // Obtén la instancia del controlador AuthController
 
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
 
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
 
    final ButtonStyle socialButtonStyle = ElevatedButton.styleFrom(
      shape: CircleBorder(),
      padding: EdgeInsets.all(16), // Sin efecto al presionar
      shadowColor: Colors.transparent, // Sin sombra
      elevation: 0, // Sin elevación
    );
 
    return Scaffold(
      backgroundColor: Color(0xFF111111), // Fondo de la pantalla
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 60),
                Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Franklin Gothic Demi'),
                ),
                Text(
                  'Please fill in the form to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF494949), fontFamily: 'Franklin Gothic Demi'),
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: _fullNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Full Name',
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
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email Address',
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
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintMaxLines: 20,
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
                TextField(
                  controller: _passwordController,
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
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _confirmPasswordController,
                  style: TextStyle(color: Colors.white),
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF494949),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    // Implement registration logic
                    return _register(_fullNameController, _usernameController, _emailController, _passwordController, _confirmPasswordController);
                  },
                  style: buttonStyle,
                ),
                SizedBox(height: 40.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF4E0566),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _authController.changeTab(0);
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
 
 
 
  // Función para comprobar los campos del registro
  void _register(TextEditingController fullNameController, TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController) {
    String fullName = fullNameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
 
    // Verifica los campos del formulario
    if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackBar('All fields are required.');
      return;
    } else if (username.length > 20) {
      _showErrorSnackBar('Username must be less than 20 characters.');
      return;
    } else if (password.length < 8 || password.length > 20) {
      _showErrorSnackBar('Password must be between 8 and 20 characters.');
      return;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%_])[A-Za-z\d!@#\$%_]{8,}$').hasMatch(password)) {
      _showErrorSnackBar('Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.');
      return;
    } else if (fullName.length > 40) {
      _showErrorSnackBar('Full name must be less than 40 characters.');
      return;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)) {
      _showErrorSnackBar('Please enter a valid email address.');
      return;
    } else if (confirmPassword != password) {
      _showErrorSnackBar('Passwords do not match.');
      return;
    } else {
      registerOk();
    }
  }
 
  void _showErrorSnackBar(String message) {
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
 
void registerOk() async {
  try {
    await registerUser(
      _fullNameController.text,
      _emailController.text,
      _usernameController.text,
      _passwordController.text,
    );
    _showErrorSnackBar('Registration successful!');
    _login(_usernameController.text, _passwordController.text,
                        context);
    _authController.changeTab(10);
  } catch (e) {
    _showErrorSnackBar('Failed to register user: $e');
  }
}
void _login(String username, String password, BuildContext context) async {
  // Obtener el token de acceso
  final token = await _token(username, password, context);
 
  if (token != null) {
    // Obtener información del usuario usando el token
    final userInfo = await getUserInfo(token);
 
    if (userInfo != null && userInfo['is_active'] == false) {
      _authController.changeTab(10);
    } else if(userInfo != null && userInfo['is_active'] != false){
      _authController.changeTab(3);
    } else {
      _authController.changeTab(9);
    }
}
}
  Future<Map<String, dynamic>> getTokenUser(String username, String password) async {
    final apiUrl = Uri.parse('http://217.182.70.161:6969/token');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
 
    if (response.statusCode == 200) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);
    }
 
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
      UserSingleton().id = jsonResponse['id'];
      UserSingleton().name = jsonResponse['full_name'];
      UserSingleton().username = jsonResponse['username'];
      UserSingleton().email = jsonResponse['email'];
      UserSingleton().isActive = jsonResponse['is_active'];
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
 
 
 
Future<Map<String, dynamic>> registerUser(String fullname, String email, String username, String password) async {
  Uri apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/register');
 
  Map<String, dynamic> body = {
    'full_name': fullname,
    'email': email,
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
 
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to register user: ${response.body}');
  }
}
 
 
}