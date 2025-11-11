class AlarmModel {
  final String id;
  final int hours;
  final int minutes;
  final DateTime scheduledTime;
  final String? selectedMusic;
  final bool isActive;
  final DateTime createdAt;

  AlarmModel({
    required this.id,
    required this.hours,
    required this.minutes,
    required this.scheduledTime,
    this.selectedMusic,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hours': hours,
      'minutes': minutes,
      'scheduledTime': scheduledTime.millisecondsSinceEpoch,
      'selectedMusic': selectedMusic,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      hours: json['hours'],
      minutes: json['minutes'],
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(json['scheduledTime']),
      selectedMusic: json['selectedMusic'],
      isActive: json['isActive'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  AlarmModel copyWith({
    String? id,
    int? hours,
    int? minutes,
    DateTime? scheduledTime,
    String? selectedMusic,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get durationDisplay {
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get timeLeftDisplay {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) return 'Expired';

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m left';
    }
    return '${minutes}m left';
  }
}
