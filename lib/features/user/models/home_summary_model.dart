class HomeSummaryModel {
  final int activeDevicesCount;
  final int deviceHistoryCount;

  HomeSummaryModel({
    required this.activeDevicesCount,
    required this.deviceHistoryCount,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return HomeSummaryModel(
      activeDevicesCount: json['activeDevicesCount'] as int,
      deviceHistoryCount: json['deviceHistoryCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeDevicesCount': activeDevicesCount,
      'deviceHistoryCount': deviceHistoryCount,
    };
  }
}
