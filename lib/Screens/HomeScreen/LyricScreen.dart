// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:BeatNow/Screens/HomeScreen/LyricEditorPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LyricScreen extends StatefulWidget {
  @override
  _LyricScreenState createState() => _LyricScreenState();
}

List<dynamic> _lyricsList = [];
List<dynamic> _lyricsList1 = [];

class _LyricScreenState extends State<LyricScreen> {
  @override
  void initState() {
    fetchLyrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: _lyricsList.length,
                itemBuilder: (context, index) {
                  List<String> lines = _lyricsList[index]['lyrics'].split('\n');
                  String firstTwoLines = lines.length > 1
                      ? lines.sublist(0, 2).join('\n')
                      : lines[0];
                  return ListTile(
                    title: Text(_lyricsList[index]['title']),
                    subtitle: Text(firstTwoLines),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        
                        deleteLyric(_lyricsList[index]['_id']);
                        setState(() {
                          _lyricsList.removeAt(index);
                        });

                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LyricEditorPage(
                                title: _lyricsList[index]['title'],
                                lyric: _lyricsList[index]['lyrics'],
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
}

void fetchLyrics() async {
  final token = UserSingleton().token;

  final response = await http.get(
    Uri.parse('http://217.182.70.161:6969/v1/api/users/lyrics'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = convert.jsonDecode(response.body);
    _lyricsList.clear();
    for (var data in jsonResponse) {
      _lyricsList.add(data);
    }
  } else {
    throw Exception('status' + response.statusCode.toString());
  }
}
void deleteLyric(String _LyricId) async {
  final token = UserSingleton().token;

  final response = await http.delete(
    Uri.parse('http://217.182.70.161:6969/v1/api/lyrics/$_LyricId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
   
  } else {
    throw Exception('status' + response.statusCode.toString());
  }
}

