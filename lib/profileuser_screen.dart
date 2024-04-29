import 'dart:io';

import 'package:BeatNow/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'auth_controller.dart'; // Ajusta la importación según la estructura de tu proyecto

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
                  final pickedFile =
                      await ImagePicker().getImage(source: ImageSource.camera);
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
                  final pickedFile =
                      await ImagePicker().getImage(source: ImageSource.gallery);
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
                    _profileImagePath =
                        'http://172.203.251.28/beatnow/res/defaultProfile.jpg';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _authController.changeTab(3);
            Get.back(); // or Navigator.pop(context) if not using GetX
          },
        ),
        title: Text(UserSingleton().name),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => _onProfileImageClicked(context),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _hasProfileImage
                    ? FileImage(
                        File(_profileImagePath!)) // Cambiado a FileImage
                    : NetworkImage(UserSingleton().profileImageUrl)
                        as ImageProvider<
                            Object>, // Convertido a ImageProvider<Object>
              ),
            ),
            SizedBox(height: 20.0),
            Text('@'+UserSingleton().username),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildStatColumn('Followers', '342'),
                _buildStatColumn('Downloads', '1.8M'),
                _buildStatColumn('Likes', '39.1M'),
              ],
            ),
            _buildSongList(),
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
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5, // Number of songs
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Song Title'),
          subtitle: Text('Liked 1.831 times'),
          trailing: Text('\$4.99'),
        );
      },
    );
  }

  


}
