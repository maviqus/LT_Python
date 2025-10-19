class Music {
  final String id;
  final String name;
  final String image;
  final String music;

  final String? category;
  final int? durationSeconds;

  const Music({
    required this.id,
    required this.name,
    required this.image,
    required this.music,
    this.category,
    this.durationSeconds,
  });

  factory Music.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    String? category,
  }) {
    return Music(
      id: id,
      name: (data['name'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      music: (data['music'] ?? '').toString(),
      category: category,
      durationSeconds: data['durationSeconds'] as int?,
    );
  }

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      music: json['music'] ?? '',
      category: json['category'],
      durationSeconds: json['durationSeconds'],
    );
  }

  String get title => name;
  String? get coverUrl => image;
  String? get audioUrl => music;
  String get artist => category ?? 'Unknown Artist';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'music': music,
      'category': category,
      'durationSeconds': durationSeconds,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'music': music,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
    };
  }
}
