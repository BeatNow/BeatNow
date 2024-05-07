import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LyricEditorPage extends StatefulWidget {
  final String title;
  final String lyric;
  final int? index;

  LyricEditorPage({required this.title, required this.lyric, this.index});

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

  @override
  void dispose() {
    _titleController.dispose();
    _lyricController.dispose();
    super.dispose();
  }

  Future<void> saveLyric() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList('titles') ?? [];
    List<String> lyrics = prefs.getStringList('lyrics') ?? [];

    if (widget.index != null && widget.index! < titles.length) {
      titles[widget.index!] = _titleController.text;
      lyrics[widget.index!] = _lyricController.text;
    } else {
      titles.add(_titleController.text);
      lyrics.add(_lyricController.text);
    }

    await prefs.setStringList('titles', titles);
    await prefs.setStringList('lyrics', lyrics);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Lyric saved!"),
      duration: Duration(seconds: 2),
    ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? 'Edit Lyric' : 'Create New Lyric'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveLyric,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextFormField(
                controller: _lyricController,
                decoration: InputDecoration(labelText: 'Lyric'),
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
