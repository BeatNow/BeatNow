import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart'; // Adjust the import according to your project structure

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

class ProfileScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

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
        title: Text('Martí Ortiz'),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/profile.jpg'), // Usa AssetImage para cargar una imagen de los recursos locales
            ),
            SizedBox(height: 20.0),
            Text('@mortizaug'),
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
