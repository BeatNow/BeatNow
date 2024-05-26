import 'dart:io';
import 'package:BeatNow/Models/OtherUserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../Controllers/auth_controller.dart'; // Ajusta la importación según la estructura de tu proyecto
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Profile Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileOtherScreen(),
    );
  }
}

class ProfileOtherScreen extends StatefulWidget {
  @override
  _ProfileOtherScreenState createState() => _ProfileOtherScreenState();
}

class _ProfileOtherScreenState extends State<ProfileOtherScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final userSingleton = OtherUserSingleton();
  bool _hasProfileImage = false; // Cambiado a falso inicialmente
  String? _profileImagePath; // Ruta de la imagen de perfil

  // Function to handle when the profile image is clicked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _authController.changeTab(3);
            Get.back(); // or Navigator.pop(context) if not using GetX
          },
        ),
        title: Text(
          "@" + OtherUserSingleton().username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212), // darker shade
              Color(0xFF0D0D0D), // even darker shade
            ],
            stops: [0.5, 1.0], // where to start and end each color
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "http://172.203.251.28/beatnow/" + OtherUserSingleton().id + "/photo_profile/photo_profile.png",
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildStatColumn('Posts', '0'),
                        SizedBox(width: 20),
                        _buildStatColumn('Following', '342'),
                        SizedBox(width: 20),
                        _buildStatColumn('Followers', '1.8M'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  OtherUserSingleton().username,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón "Message"
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre los botones
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón "Follow"
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Follow',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.5, // Proporción 2:1 (alto:ancho)
                ),
                itemCount: 30, // Cantidad de elementos en la cuadrícula
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey, // Color de fondo temporal
                    child: Center(
                      child: Text('Item $index',
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    );
  }
}
