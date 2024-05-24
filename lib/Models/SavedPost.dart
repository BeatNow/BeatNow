class SavedPost {
  final String id;
  final String postId;
  final String userId;
  final String savedDate;

  SavedPost({
    required this.id,
    required this.postId,
    required this.userId,
    required this.savedDate,
  });

  static SavedPost fromJson(Map<String, dynamic> json) {
    return SavedPost(
      id: json['_id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      savedDate: json['saved_date'] as String,
    );
  }
}