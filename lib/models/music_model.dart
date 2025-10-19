class Music {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String audioUrl;
  final String? imageUrl;
  final int duration;
  final String? genre;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  final String fileType;
  final bool isVideo;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.audioUrl,
    this.imageUrl,
    required this.duration,
    this.genre,
    required this.createdAt,
    this.metadata,
    this.fileType = 'mp3',
    this.isVideo = false,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String?,
      audioUrl: json['audioUrl'] as String,
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as int? ?? 0,
      genre: json['genre'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      fileType: json['fileType'] as String? ?? 'mp3',
      isVideo: json['isVideo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'duration': duration,
      'genre': genre,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
      'fileType': fileType,
      'isVideo': isVideo,
    };
  }

  Music copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? audioUrl,
    String? imageUrl,
    int? duration,
    String? genre,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    String? fileType,
    bool? isVideo,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      fileType: fileType ?? this.fileType,
      isVideo: isVideo ?? this.isVideo,
    );
  }

  @override
  String toString() {
    return 'Music(id: $id, title: $title, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Music && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
