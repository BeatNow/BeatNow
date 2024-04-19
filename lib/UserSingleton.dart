class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();

  late String _name = '';
  late String _username = '';
  late String _email = '';
  late String _profileImageUrl = '';

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();

  String get name => _name;
  String get username => _username;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;

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
}
