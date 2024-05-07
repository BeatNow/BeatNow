import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Controllers/auth_controller.dart'; // Ajusta la importación según la estructura de tu proyecto
import 'package:BeatNow/Models/UserSingleton.dart';

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
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final userSingleton = UserSingleton();
  bool _hasProfileImage = false; // Cambiado a falso inicialmente
  String? _profileImagePath; // Ruta de la imagen de perfil

  // Function to handle when the profile image is clicked
  void _onProfileImageClicked(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  // Add logic to take photo
                  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImagePath = pickedFile.path;
                      _hasProfileImage = true;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  // Check and request permission to access gallery
                  await Permission.photos.request();
                  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImagePath = pickedFile.path;
                      _hasProfileImage = true;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove Profile Photo'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  setState(() {
                    _profileImagePath = 'http://172.203.251.28/beatnow/res/defaultProfile.jpg';
                    _hasProfileImage = false;
                  });
                },
              ),
              ListTile(
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
          "@"+UserSingleton().username,
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
                  onTap: () => _onProfileImageClicked(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _hasProfileImage
                        ? FileImage(File(_profileImagePath!)) // Cambiado a FileImage
                        : NetworkImage(UserSingleton().profileImageUrl) as ImageProvider<Object>, // Convertido a ImageProvider<Object>
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
                  UserSingleton().name,
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
                  OutlinedButton(
                    onPressed: () {
                      // Acción cuando se presiona el botón "Editar Perfil"
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      'Editar Perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Acción cuando se presiona el botón "Configuración de la Cuenta"
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      'Configuración de la Cuenta',
                      style: TextStyle(color: Colors.white),
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
                      child: Text('Item $index', style: TextStyle(color: Colors.white)),
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
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    );
  }
}

