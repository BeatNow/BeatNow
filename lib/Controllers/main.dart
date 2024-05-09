import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/forgot_password_screen.dart';
import 'auth_controller.dart';
import '../Screens/login_screen.dart';
import '../Screens/signup_screen.dart';
import '../Screens/profileuser_screen.dart';
import '../Screens/home_screen.dart';// Import ProfileScreen
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

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

