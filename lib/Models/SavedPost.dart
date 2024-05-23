// Definición del modelo de datos
import 'package:BeatNow/Models/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SavedPost {
  String _id;
  String _postId;
  String _userId;
  String _savedDate;

  SavedPost(this._id, this._postId, this._userId, this._savedDate);

  SavedPost.withDetails(this._id, this._postId, this._userId, this._savedDate);

  // Getters
  String get id => _id;
  String get postId => _postId;
  String get userId => _userId;
  String get savedDate => _savedDate;
  String get coverImageUrl => 'http://172.203.251.28/beatnow/$_userId/posts/$_id/caratula.jpg';

  // Setters
  set id(String value) {
    _id = value;
  }

  set postId(String value) {
    _postId = value;
  }

  set userId(String value) {
    _userId = value;
  }

  set savedDate(String value) {
    _savedDate = value;
  }

  static SavedPost fromJson(Map<String, dynamic> json) {
    return SavedPost.withDetails(
      json['_id'] as String,
      json['post_id'] as String,
      json['user_id'] as String,
      json['saved_date'] as String,
    );
  }
}
