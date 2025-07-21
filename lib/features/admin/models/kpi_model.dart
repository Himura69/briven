class KpiModel {
  final int totalDevices;
  final int inUse;
  final int available;
  final int damaged;
  final List<ActivityLogModel> activityLog;

  KpiModel({
    required this.totalDevices,
    required this.inUse,
    required this.available,
    required this.damaged,
    required this.activityLog,
  });

  factory KpiModel.fromJson(Map<String, dynamic> json) {
    return KpiModel(
      totalDevices: json['totalDevices'] ?? 0,
      inUse: json['inUse'] ?? 0,
      available: json['available'] ?? 0,
      damaged: json['damaged'] ?? 0,
      activityLog: (json['activityLog'] as List<dynamic>?)
              ?.map((log) => ActivityLogModel.fromJson(log))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDevices': totalDevices,
      'inUse': inUse,
      'available': available,
      'damaged': damaged,
      'activityLog': activityLog.map((log) => log.toJson()).toList(),
    };
  }
}

class ActivityLogModel {
  final String type;
  final String category;
  final String title;
  final String description;
  final String user;
  final String date;
  final String time;

  ActivityLogModel({
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.user,
    required this.date,
    required this.time,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      user: json['user'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'title': title,
      'description': description,
      'user': user,
      'date': date,
      'time': time,
    };
  }
}