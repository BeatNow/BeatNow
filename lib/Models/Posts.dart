class Posts {
  static final Posts _instance = Posts._internal();

  late String _id;
  late String _username;
  late String _description;
  late DateTime publicationDate;
  late int _likes;
  late int _dislikes;
  late int _saves;
  late bool _liked;
  late bool _disliked;

  factory Posts() {
    return _instance;
  }

  Posts._internal() {
    // Inicializar con valores predeterminados
    _id = '';
    _username = '';
    _description = '';
    publicationDate = DateTime.now();
    _likes = 0;
    _dislikes = 0;
    _saves = 0;
    _liked = false;
    _disliked = false;
  }

  // Constructor para inicializar los valores
  Posts.withDetails(String id, String username, String description, DateTime publicationDate, int likes, int dislikes, int saves, bool liked, bool disliked) {
    _id = id;
    _username = username;
    _description = description;
    this.publicationDate = publicationDate;
    _likes = likes;
    _dislikes = dislikes;
    _saves = saves;
    _liked = liked;
    _disliked = disliked;
  }

  String get username => _username;
  String get profileImageUrl => 'http://172.203.251.28/beatnow/$_username/posts/$_id/caratula.jpg';
  String get description => _description;
  DateTime get date => publicationDate;
  int get likes => _likes;
  int get dislikes => _dislikes;
  int get saves => _saves;
  bool get liked => _liked;
  bool get disliked => _disliked;

  set username(String value) {
    _username = value;
  }

  set description(String value) {
    _description = value;
  }

  set likes(int value) {
    _likes = value;
  }

  set dislikes(int value) {
    _dislikes = value;
  }

  set saves(int value) {
    _saves = value;
  }

  set liked(bool value) {
    _liked = value;
  }

  set disliked(bool value) {
    _disliked = value;
  }

  static Posts fromJson(Map<String, dynamic> json) {
    return Posts.withDetails(
      json['id'] as String,
      json['username'] as String,
      json['description'] as String,
      DateTime.parse(json['publicationDate'] as String),
      json['likes'] as int,
      json['dislikes'] as int,
      json['saves'] as int,
      json['liked'] as bool,
      json['disliked'] as bool,
    );
  }
}
