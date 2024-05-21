import 'package:BeatNow/Controllers/auth_controller.dart';
import 'package:BeatNow/Models/Posts.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:BeatNow/Screens/HomeScreen/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BeatNow/Screens/HomeScreen/LyricEditorPage.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreenState extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenState> {
  final AuthController _authController = Get.find<AuthController>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Posts> _gifList = [];
  int _selectedIndex = 1;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  Future<void> _loadInitialPosts() async {
    // Cargar los primeros tres posts
    for (int i = 0; i < 3; i++) {
      await _getNextPost();
    }
  }

  Future<void> _getNextPost() async {
    try {
      final postInfo = await getPostInfo();
      setState(() {
        _gifList.add(Posts.withDetails(
            postInfo['_id'].toString(),
            postInfo['creator_username'].toString(),
            postInfo['description'],
            postInfo['likes'],
            postInfo['dislikes'],
            postInfo['saves'],
            postInfo['isLiked'],
            postInfo['user_id'].toString(),
            postInfo['audio_format'].toString()));
      });
    } catch (error) {
      print('Error fetching next post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      _buildPage1(),
      _buildCarousel(context),
      _buildLyricsPage(),
    ];
    return Scaffold(
      appBar: _selectedIndex == 2 || _selectedIndex == 0
          ? null
          : AppBar(
              // Removiendo el appbar en la página de letras
              leading: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _authController.changeTab(4);
                },
                elevation: 0,
                child: CircleAvatar(
                  radius: 18, // Ajusta el tamaño del avatar según sea necesario
                  backgroundImage: NetworkImage(
                    "${UserSingleton().profileImageUrl}",
                  ),
                ),
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
                    child: const Text('Following',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                  const VerticalDivider(color: Colors.white),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('For You',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _authController.changeTab(6);
                  },
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
              child: Icon(Icons.bookmark,
                  color:
                      _selectedIndex == 0 ? Color(0xFF8731E4) : Colors.white),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: _selectedIndex == 1
                  ? Image.asset('assets/images/icono_central.png',
                      width: 37, height: 37, fit: BoxFit.cover)
                  : Image.asset('assets/images/icono_central_blanco.png',
                      width: 35, height: 35, fit: BoxFit.cover),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Icon(Icons.edit,
                  color:
                      _selectedIndex == 2 ? Color(0xFF8731E4) : Colors.white),
            ),
            label: ' ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            AudioPlayer().stop();
          });
        },
        selectedFontSize: 0,
        unselectedFontSize: 0,
        backgroundColor: Color(0xFF0B0B0B),
      ),
    );
  }

  Widget _buildPage1() {
    return SavedScreen();
  }

  Widget _buildLyricsPage() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final prefs = snapshot.data!;
        List<String> titles = prefs.getStringList('titles') ?? [];
        List<String> lyrics = prefs.getStringList('lyrics') ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 50.0), // Incrementando el espacio vertical
              child: Text(
                'Your Lyrics',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold), // Aumentando el tamaño del texto
                textAlign: TextAlign.center, // Centrando el texto
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  List<String> lines = lyrics[index].split('\n');
                  String firstTwoLines =
                      lines.length > 1 ? lines[index] : lines[0];
                  return ListTile(
                    title: Text(titles[index]),
                    subtitle: Text(firstTwoLines),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        titles.removeAt(index);
                        lyrics.removeAt(index);
                        await prefs.setStringList('titles', titles);
                        await prefs.setStringList('lyrics', lyrics);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LyricEditorPage(
                                title: titles[index],
                                lyric: lyrics[index],
                                index: index)),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 155),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 100.0, // Ancho deseado para el fondo del botón
                  height: 60.0, // Alto deseado para el fondo del botón
                  color: Colors.black,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LyricEditorPage(
                                title: "", lyric: "", index: null)),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF8731E4),
                      size:
                          30, // Ajusta el tamaño del icono según sea necesario
                    ),
                    backgroundColor: Colors
                        .transparent, // Fondo transparente para el botón flotante
                    elevation: 0, // Sin elevación para el botón flotante
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        enlargeCenterPage: false,
        autoPlay: false,
        viewportFraction: 1.0,
        scrollDirection: Axis.vertical,
        onPageChanged: (index, _) {
          // Cuando el usuario cambie de post, obtener el siguiente post
          setState(() {
            _currentIndex = index;
            _loadInitialPosts();
            if (_selectedIndex == 2 || _selectedIndex == 0) {
              _audioPlayer.stop();
            } else if (_selectedIndex == 1) {
              _playAudio(_gifList[_currentIndex].audioUrl);
            }
          });
          if (index >= _gifList.length - 3) {
            _loadMorePosts();
          }
        },
      ),
      itemCount: _gifList.length,
      itemBuilder: (context, index, _) {
        final item = _gifList[index];
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () {
                _audioPlayer.pause();
              },
              child: Image.network(
                item.profileImageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
            _buildDynamicButtons(context, index, _gifList),
          ],
        );
      },
    );
  }

  void _loadMorePosts() async {
    // Cargar tres posts más al llegar al final del carrusel
    for (int i = 0; i < 3; i++) {
      await _getNextPost();
    }
  }

  Widget _buildDynamicButtons(
  BuildContext context, int index, List<Posts> gifList) {
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
              padding: const EdgeInsets.only(
                  left: 10), // Añadir padding a la izquierda
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gifList[index].username,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 10),
                  Text(gifList[index].description,
                      style: TextStyle(color: Colors.white, fontSize: 15)),
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
              backgroundColor: Colors.transparent,
              onPressed: () {},
              elevation: 0,
              child: CircleAvatar(
                radius: 20, // Ajusta el tamaño del avatar según sea necesario
                backgroundImage: NetworkImage(
                  'http://172.203.251.28/beatnow/${gifList[index].userId}/photo_profile/photo_profile.png',
                ),
              ),
            ),
            SizedBox(height: 25),
            FloatingActionButton(
              child: Icon(
                Icons.favorite,
                color: _gifList[index].liked ? Colors.purple :  Colors.white ,
                size: 35,
              ),
              backgroundColor: Colors.transparent,
              onPressed: () {
                _handleLikeButton(gifList[index].id); // Aquí se pasa el índice correcto
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


  Future<void> _playAudio(String url) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  void _handleLikeButton(String postId) async {
  try {
    String apiUrl = '';
    if (_gifList[_currentIndex].liked == true) {
      // Si ya le dio "like", se eliminará el "like"
      apiUrl =
          'http://217.182.70.161:6969/v1/api/interactions/unlike/$postId';
    } else {
      // Si aún no ha dado "like", se agregará el "like"
      apiUrl = 'http://217.182.70.161:6969/v1/api/interactions/like/$postId';
    }

    final token = UserSingleton().token;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        // Actualizar el estado de "me gusta" en la lista de publicaciones
        final postIndex = _gifList.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          _gifList[postIndex].liked = !_gifList[postIndex].liked;
        }
      });
    } else {
      throw Exception('Failed to update post like status');
    }
  } catch (error) {
    print('Error al manejar el botón de like: $error');
    // Manejar el error aquí
  }
}

}

Future<Map<String, dynamic>> getPostInfo() async {
  final apiUrl = 'http://217.182.70.161:6969/v1/api/posts/random';
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
