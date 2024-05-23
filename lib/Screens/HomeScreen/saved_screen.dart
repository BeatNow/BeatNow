import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreen createState() => _SavedScreen();
}

class _SavedScreen extends State<SavedScreen> {
  late Future<List<dynamic>> _savedPosts;

  @override
  void initState() {
    super.initState();
    _savedPosts = getSavedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Beats',
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
              Color(0xFF121212), // sombra más oscura
              Color(0xFF0D0D0D), // incluso más oscura
            ],
            stops: [0.5, 1.0], // dónde comenzar y terminar cada color
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _savedPosts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.5, // Proporción 2:1 (alto:ancho)
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data![index]['coverImageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Por defecto, muestra un loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<List<dynamic>> getSavedPosts() async {
    final apiUrl = 'http://217.182.70.161:6969/v1/api/users/saved-posts';
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
}