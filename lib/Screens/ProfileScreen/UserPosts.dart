class UserPosts {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String genre;
  final List<String> moods;
  final List<String> instruments;
  final int bpm;
  final String userId;
  final DateTime publicationDate;
  final String audioFormat;
  final int likes;
  final int saves;

  UserPosts({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.genre,
    required this.moods,
    required this.instruments,
    required this.bpm,
    required this.userId,
    required this.publicationDate,
    required this.audioFormat,
    required this.likes,
    required this.saves,
  });

  static UserPosts fromJson(Map<String, dynamic> json) {
    return UserPosts(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      genre: json['genre'] as String,
      moods: List<String>.from(json['moods'] ?? []),
      instruments: List<String>.from(json['instruments'] ?? []),
      bpm: json['bpm'] as int,
      userId: json['user_id'] as String,
      publicationDate: DateTime.parse(json['publication_date'] as String),
      audioFormat: json['audio_format'] as String,
      likes: json['likes'] as int,
      saves: json['saves'] as int,
    );
  }
}
