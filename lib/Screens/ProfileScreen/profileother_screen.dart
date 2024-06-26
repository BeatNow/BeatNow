import 'dart:io';
import 'dart:convert';
import 'package:BeatNow/Models/OtherUserSingleton.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Controllers/auth_controller.dart'; // Ajusta la importación según la estructura de tu proyecto

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
  List<dynamic>? _posts; 
  Map<String, int>? _followersFollowing;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Future<void> _initializeProfileData() async {
    await _fetchUserPosts(OtherUserSingleton().username);
    _followersFollowing = await _fetchFollowersFollowing(OtherUserSingleton().id);
    setState(() {}); // Asegúrate de actualizar la interfaz de usuario después de cargar los datos
  }

  Future<void> _fetchUserPosts(String username) async {
    Uri apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/posts/$username');
    final token = UserSingleton().token;

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response JSON: $jsonResponse'); // Debugging line to print the JSON response
        setState(() {
          _posts = jsonResponse;
        });
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user posts: $error');
    }
  }

  Future<Map<String, int>> _fetchFollowersFollowing(String userId) async {
    Uri apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/profile/$userId');
    final token = UserSingleton().token;

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return {
          'followers': jsonResponse['followers'],
          'following': jsonResponse['following'],
        };
      } else {
        throw Exception('Failed to load followers and following');
      }
    } catch (error) {
      print('Error fetching followers and following: $error');
      return {'followers': 0, 'following': 0}; // En caso de error, retorna valores predeterminados
    }
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
                        _buildStatColumn('Posts', '${_posts?.length ?? 0}'),
                        SizedBox(width: 20),
                        _buildStatColumn('Following', '${_followersFollowing?['following']}'),
                        SizedBox(width: 20),
                        _buildStatColumn('Followers', '${_followersFollowing?['followers']}'),
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
              child: _posts == null
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 9 / 16, // Proporción 16:9 vertical
                      ),
                      itemCount: _posts!.length,
                      itemBuilder: (context, index) {
                        final post = _posts![index];
                        print('Post: $post'); // Debugging line to print each post
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'http://172.203.251.28/beatnow/${post['user_id']}/posts/${post['_id']}/caratula.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
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
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
    Future<int> _isFollowing(String userId) async {
    Uri apiUrl = Uri.parse('http://217.182.70.161:6969/v1/api/users/profile/$userId');
    final token = userSingleton.token;

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          ' Authorization ': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
         return jsonResponse['is_following'];
      } else {
        throw Exception('Failed to load followers and following');
      }
    } catch (error) {
      print('Error fetching followers and following: $error');
       return 0; // En caso de error, retorna valores predeterminados
    }
  }
}
