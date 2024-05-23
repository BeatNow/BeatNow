import 'package:BeatNow/Controllers/auth_controller.dart';
import 'package:BeatNow/Models/OtherUserSingleton.dart';
import 'package:BeatNow/Models/Posts.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:BeatNow/Screens/HomeScreen/saved_screen.dart';
import 'package:BeatNow/Screens/ProfileScreen/profileuser_screen.dart';
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
  int _currentIndex = 0;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  @override
  void dispose() {
    // Detener el reproductor de audio cuando el widget se elimine
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadInitialPosts() async {
    // Cargar los primeros tres posts
    await _getNextPost();
    //Hacer condicional que si no encuentra posts que no haga nada
    

  }

  Future<void> _getNextPost() async {
    try {
      final postInfo = await getPostInfo();
      setState(() {
        _gifList.add(Posts.withDetails(
            postInfo['_id'].toString(),
            postInfo['title'],
            postInfo['creator_username'].toString(),
            postInfo['description'],
            postInfo['likes'],
            postInfo['saves'],
            postInfo['isLiked'],
            postInfo['isSaved'],
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
              leading: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _authController.changeTab(4);
                },
                elevation: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage("${UserSingleton().profileImageUrl}"),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        OtherUserSingleton().username =
                            _gifList[_currentIndex].username;
                        OtherUserSingleton().id =
                            _gifList[_currentIndex].userId;
                        OtherUserSingleton().name =
                            _gifList[_currentIndex].username;
                        _authController.changeTab(8);
                      },
                      child: _gifList.isNotEmpty
                          ? Text(
                              "@" + _gifList[_currentIndex].username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            )
                          : Text("")),
                  const VerticalDivider(color: Colors.white),
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
            _audioPlayer.stop();
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
              child: Text(
                'Your Lyrics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  List<String> lines = lyrics[index].split('\n');
                  String firstTwoLines = lines.length > 1
                      ? lines.sublist(0, 2).join('\n')
                      : lines[0];
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
                  width: 100.0,
                  height: 60.0,
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
                      size: 30,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
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
  // Reproducir la música al inicio del widget
  return CarouselSlider.builder(
    options: CarouselOptions(
      height: MediaQuery.of(context).size.height,
      enlargeCenterPage: false,
      autoPlay: false,
      viewportFraction: 1.0,
      scrollDirection: Axis.vertical,
      onPageChanged: (index, _) {
        _loadMorePosts();

        setState(() {
          _currentIndex = index;
          UserSingleton().current = _currentIndex;
          _loadInitialPosts();
          if (_selectedIndex == 2 || _selectedIndex == 0) {
            _audioPlayer.stop();
          } else if (_selectedIndex == 1) {
            if (_gifList.length > _currentIndex) {
              _playAudio(_gifList[_currentIndex].audioUrl);
            }
          }
        });
        if (index >= _gifList.length - 3) {
          _loadMorePosts();
        }
      },
    ),
    itemCount: _gifList.length,
    itemBuilder: (context, index, _) {
      if (_gifList.length > index) {
        final item = _gifList[index];
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () {
                if (_isPlaying) {
                  _audioPlayer.pause();
                  _isPlaying = false;
                } else {
                  _isPlaying = true;
                  _audioPlayer.resume();
                }
                
              },
              child: Image.network(
                item.coverImageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
            _buildDynamicButtons(context, index),
          ],
        );
      } else {
        return Container(); // O cualquier otro Widget de carga o de relleno
      }
    },
  );
}


  void _loadMorePosts() async {
    // Cargar tres posts más al llegar al final del carrusel
    for (int i = 0; i < 3; i++) {
      await _getNextPost();
    }
  }

  Widget _buildDynamicButtons(BuildContext context, int index) {
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
                    Text(_gifList[index].title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(_gifList[index].description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
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
                onPressed: () {
                  OtherUserSingleton().username =
                      _gifList[_currentIndex].username;
                  OtherUserSingleton().id = _gifList[_currentIndex].userId;
                  OtherUserSingleton().name = _gifList[_currentIndex].username;

                  _authController.changeTab(8);
                },
                elevation: 0,
                child: CircleAvatar(
                  radius: 20, // Ajusta el tamaño del avatar según sea necesario
                  backgroundImage: NetworkImage(
                    'http://172.203.251.28/beatnow/${_gifList[index].userId}/photo_profile/photo_profile.png',
                  ),
                ),
              ),
              SizedBox(height: 25),
              Column(
                children: [
                  FloatingActionButton(
                    child: Icon(
                      Icons.favorite,
                      color:
                          _gifList[index].liked ? Colors.purple : Colors.white,
                      size: 35,
                    ),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        // Cambiar el estado de "liked"
                        _handleLikeButton(_gifList[index].id);
                        for (int i = 0; i < _gifList.length; i++) {
                          if (_gifList[i].id == _gifList[index].id) {
                            _gifList[i].liked = !_gifList[i].liked;
                          }
                        }
                      });
                      // Llamar a la función para manejar la lógica de like/unlike
                    },
                    elevation: 0,
                  ),
                  SizedBox(height: 5),
                  Text(
                    // Convertir int a String
                    _gifList[index].likes.toString(), // Convertir int a String
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 15),
              FloatingActionButton(
                child: Icon(
                  Icons.bookmark,
                  color: _gifList[index].saved
                      ? Color.fromARGB(255, 252, 212, 81)
                      : Colors.white,
                  size: 35,
                ),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    _handleSaveButton(_gifList[index].id);
                    for (int i = 0; i < _gifList.length; i++) {
                      if (_gifList[i].id == _gifList[index].id) {
                        _gifList[i].saved = !_gifList[i].saved;
                      }
                    }
                  });
                  // Llamar a la función para manejar la lógica de like/unlike
                },
                elevation: 0,
              ),
              SizedBox(height: 25),
              FloatingActionButton(
                child: Icon(Icons.ios_share, color: Colors.white, size: 35),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Acción para 'share'.
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
        if (_gifList[_currentIndex].likes < 0) {
          _gifList[_currentIndex].likes = 0;
        }
        _gifList[_currentIndex].likes = _gifList[_currentIndex].likes - 1;
      } else {
        // Si aún no ha dado "like", se agregará el "like"
        apiUrl = 'http://217.182.70.161:6969/v1/api/interactions/like/$postId';
        _gifList[_currentIndex].likes = _gifList[_currentIndex].likes + 1;
      }

      final token = UserSingleton().token;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
      } else {
        throw Exception('Failed to update post like status');
      }
    } catch (error) {
      print('Error al manejar el botón de like: $error');
      // Manejar el error aquí
    }
  }

  void _handleSaveButton(String postId) async {
    try {
      String apiUrl = '';
      if (_gifList[_currentIndex].saved == true) {
        apiUrl =
            'http://217.182.70.161:6969/v1/api/interactions/unsave/$postId';
      } else {
        apiUrl = 'http://217.182.70.161:6969/v1/api/interactions/save/$postId';
      }

      final token = UserSingleton().token;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
      } else {
        throw Exception('Failed to update post saved status');
      }
    } catch (error) {
      print('Error al manejar el botón de guardado: $error');
      // Manejar el error aquí
    }
  }
}

Future<Map<String, dynamic>> getPostInfo() async {
  const apiUrl = 'http://217.182.70.161:6969/v1/api/posts/random';
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
