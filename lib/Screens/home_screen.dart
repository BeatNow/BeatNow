import 'package:BeatNow/Models/Posts.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:get/get_core/src/get_main.dart';
import '../Controllers/auth_controller.dart';

class HomeScreenState extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenState> {
  final AuthController _authController = Get.find<AuthController>(); 
  int _selectedIndex = 1;

  List<Posts> _gifList = []; // Lista de posts obtenidos de la API

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      _buildPage1(),
      _buildCarousel(context),
      _buildPage3(),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            _authController.changeTab(4);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text('Following', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
            const VerticalDivider(color: Colors.white),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text('For You', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color(0xFF111111),
      ),
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Icon(Icons.bookmark, color: _selectedIndex == 0 ? Color(0xFF8731E4) : Colors.white),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: _selectedIndex == 1 ? Image.asset('assets/images/icono_central.png', width: 37, height: 37, fit: BoxFit.cover) : Image.asset('assets/images/icono_central_blanco.png', width: 35, height: 35, fit: BoxFit.cover),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Icon(Icons.edit, color: _selectedIndex == 2 ? Color(0xFF8731E4) : Colors.white),
            ),
            label: ' ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 0,
        unselectedFontSize: 0,
        backgroundColor: Color(0xFF0B0B0B),
      ),
    );
  }

  Widget _buildPage1() {
    return Center(
      child: Text(
        'Página 1',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPage3() {
    return Center(
      child: Text(
        'Página 3',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getPostInfo(), // Obtener el primer post al inicio
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final postInfo = snapshot.data!;
          _gifList.add(Posts.withDetails(
            postInfo['_id'].toString(),
            postInfo['creator_username'].toString(),
            postInfo['description'],
            DateTime.now(),
            0,
            0,
            0,
            false,
            false,
          ));

          return CarouselSlider.builder(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enlargeCenterPage: false,
              autoPlay: false,
              viewportFraction: 1.0,
              scrollDirection: Axis.vertical,
              onPageChanged: (index, _) {
                // Cuando el usuario cambie de post, obtener el siguiente post
                if (index >= _gifList.length - 1) {
                  getNextPost();
                }
              },
            ),
            itemCount: _gifList.length,
            itemBuilder: (context, index, _) {
              final item = _gifList[index];
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.network(
                    item.profileImageUrl,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                  _buildDynamicButtons(context, index, _gifList),
                ],
              );
            },
          );
        }
      },
    );
  }

  // Función para obtener el siguiente post de la API
  void getNextPost() async {
    try {
      final postInfo = await getPostInfo();
      setState(() {
        _gifList.add(Posts.withDetails(
          postInfo['_id'].toString(),
          postInfo['creator_username'].toString(),
          postInfo['description'],
          DateTime.now(),
          0,
          0,
          0,
          false,
          false,
        ));
      });
    } catch (error) {
      print('Error fetching next post: $error');
    }
  }

  Widget _buildDynamicButtons(BuildContext context, int index, List<Posts> gifList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10), // Añadir padding a la izquierda
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gifList[index].username, style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 10),
                    Text(gifList[index].description, style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(Icons.supervised_user_circle, color: Colors.white, size: 50),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Action for 'share'.
                },
                elevation: 0,
              ),
              SizedBox(height: 25),
              FloatingActionButton(
                child: Icon(Icons.favorite, color: gifList[index].liked ? Colors.purple : Colors.white, size: 35),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    gifList[index].liked = !gifList[index].liked;
                  });
                },
                elevation: 0,
              ),
              SizedBox(height: 25),
              FloatingActionButton(
                child: Icon(Icons.shopping_cart, color: Colors.white, size: 35),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Action for 'share'.
                },
                elevation: 0,
              ),
              SizedBox(height: 25),
              FloatingActionButton(
                child: Icon(Icons.ios_share, color: Colors.white, size: 35),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Action for 'buy'.
                },
                elevation: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> getPostInfo() async {
  final apiUrl = 'http://217.182.70.161:6969/v1/api/posts/random-publication';
  final token = UserSingleton().token;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to fetch post information');
  }
}
