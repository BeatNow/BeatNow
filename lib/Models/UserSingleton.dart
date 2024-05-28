class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();
  late String _id = '';
  late String _name = '';
  late String _username = '';
  late String _email = '';
 late String _profileImageUrl = 'http://172.203.251.28/beatnow/' + _id + '/photo_profile/photo_profile.png';
 late String _defaultProfileImageUrl = 'http://172.203.251.28/beatnow/default/default_photo.png';
  late String _token = '';
  late int _current= 0;
late bool _isActive = false;
  factory UserSingleton() {
    return _instance;
  }
 
  UserSingleton._internal();
 
  String get name => _name;
  String get username => _username;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;
  String get defaultProfileImageUrl => _defaultProfileImageUrl;
  String get token => _token;
  String get id => _id;
  int get current => _current;
  bool get isActive => _isActive;
 
  set id(String value) {
    _id = value;
  }
  set name(String value) {
    _name = value;
  }
 
  set username(String value) {
    _username = value;
  }
 
  set email(String value) {
    _email = value;
  }
 
  set profileImageUrl(String value) {
    _profileImageUrl = value;
  }
 
  set defaultProfileImageUrl(String value) {
    _defaultProfileImageUrl = value;
  }
  set token(String value) {
    _token = value;
  }
  set current(int value) {
    _current = value;
  }
  set isActive(bool value) { // Nuevo setter
    _isActive = value;
  }
 
  List<String> get user => [_id, _name, _username, _email, _profileImageUrl, _defaultProfileImageUrl, _token, _current.toString(), isActive.toString()];
}
 