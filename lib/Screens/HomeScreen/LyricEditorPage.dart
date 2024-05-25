import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:BeatNow/Models/UserSingleton.dart';

class LyricEditorPage extends StatefulWidget {
  final String title;
  final String lyric;
  final int? index;
  final String lyricId;
  final bool isEditing;
  LyricEditorPage(
      {required this.title,
      required this.lyric,
      this.index,
      this.isEditing = false,
      this.lyricId = ''});

  @override
  _LyricEditorPageState createState() => _LyricEditorPageState();
}

class _LyricEditorPageState extends State<LyricEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _lyricController;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _lyricController = TextEditingController(text: widget.lyric);
    _checkSpeechAvailability();
  }

  Future<void> _checkSpeechAvailability() async {
    bool available = await _speech.initialize();
    if (available) {
      _initializeSpeechToText();
    } else {
      print('Speech recognition is not available');
    }
  }

  Future<void> _initializeSpeechToText() async {
    if (!_speech.isAvailable) {
      print('Speech recognition is not available');
      return;
    }

    await _speech.initialize();
    if (!_speech.isAvailable) {
      print('Speech recognition is not available');
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            _lyricController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      _speech.stop();
    }
    setState(() {
      _isListening = !_isListening;
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _lyricController.text = result.recognizedWords;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> saveLyric() async {
    String apiUrl = "http://217.182.70.161:6969/v1/api/lyrics/";
    final token = UserSingleton().token; // get the user token

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer $token', // include the token in the request headers
      },
      body: jsonEncode(<String, String>{
        'title': _titleController.text,
        'lyrics': _lyricController.text,
        'post_id': '664f749c516116a47bb171f3',
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lyric saved!"),
        duration: Duration(seconds: 2),
      ));
    } else {
      print(
          'Failed to save lyric. Status code: ${response.statusCode}. Response body: ${response.body}');
      throw Exception('Failed to save lyric.');
    }
  }

  Future<void> updateLyric(String PostId) async {
    String apiUrl = "http://217.182.70.161:6969/v1/api/lyrics/$PostId";
    final token = UserSingleton().token; // get the user token

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer $token', // include the token in the request headers
      },
      body: jsonEncode(<String, String>{
        'title': _titleController.text,
        'lyrics': _lyricController.text,
        'post_id': '664f749c516116a47bb171f3',
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lyric Updated Succesfully!"),
        duration: Duration(seconds: 2),
      ));
    } else {
      print(
          'Failed to update lyric. Status code: ${response.statusCode}. Response body: ${response.body}');
      throw Exception('Failed to update lyric.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyric Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (widget.isEditing) {
                updateLyric(widget.lyricId);
                
              } else {
                saveLyric();
              }
            },
          ),
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            onPressed: _toggleListening,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 14.0),
            Expanded(
              child: TextFormField(
                controller: _lyricController,
                decoration: InputDecoration(
                  hintText: 'Type or speak your lyrics here...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
