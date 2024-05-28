class Posts {
  static final Posts _instance = Posts._internal();

  late String _id;
  late String _title;
  late String _username;
  late String _userId;
  late String _description;
  late DateTime publicationDate;
  late int _likes;

  late int _saves;
  late bool _liked;
  late bool _saved;
  late String _audioformat;

  factory Posts() {
    return _instance;
  }

  Posts._internal() {
    // Inicializar con valores predeterminados
    _id = '';
    _title = '';
    _username = '';
    _description = '';
    _likes = 0;
    _saves = 0;
    _liked = false;
    _saved = false;
    _userId = '';
    _audioformat = '';
  }

  // Constructor para inicializar los valores
  Posts.withDetails(String id, String title, String username, String description, int likes, int saves, bool liked, bool saved, String userId, String audioformat) {
    _id = id;
    _title = title;
    _username = username;
    _description = description;
    _likes = likes;
    _saves = saves;
    _liked = liked;
    _saved = saved;
    _userId = userId;
    _audioformat = audioformat;
  }

  String get username => _username;
  String get title => _title;
  String get coverImageUrl => 'http://172.203.251.28/beatnow/$_userId/posts/$_id/caratula.jpg';
  String get audioUrl => 'http://172.203.251.28/beatnow/$_userId/posts/$_id/audio.$_audioformat';
  String get description => _description;
  DateTime get date => publicationDate;
  int get likes => _likes;
  int get saves => _saves;
  bool get liked => _liked;
  bool get saved => _saved;
  String get id => _id;
  String get userId => _userId;
  String get audioformat => _audioformat;

  set username(String value) {
    _username = value;
  }

  set title(String value) {
    _title = value;
  }

  set userId(String value) {
    _userId = value;
  }

  set description(String value) {
    _description = value;
  }

  set likes(int value) {
    _likes = value;
  }


  set saves(int value) {
    _saves = value;
  }

  set liked(bool value) {
    _liked = value;
  }

  set saved(bool value) {
    _saved = value;
  }

  set audioformat(String value) {
    _audioformat = value;
  }

  static Posts fromJson(Map<String, dynamic> json) {
    return Posts.withDetails(
      json['id'] as String,
      json['title'] as String,
      json['username'] as String,
      json['description'] as String,
      json['likes'] as int,
      json['saves'] as int,
      json['liked'] as bool,
      json['saved'] as bool,
      json['userId'] as String,
      json['audio_format'] as String,
    );
  }
}
