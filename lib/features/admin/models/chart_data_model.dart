class ChartDataModel {
  final List<DeviceConditionData> deviceConditions;
  final List<DevicesPerBranchData> devicesPerBranch;

  ChartDataModel({
    required this.deviceConditions,
    required this.devicesPerBranch,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      deviceConditions: (json['deviceConditions'] as List<dynamic>? ?? [])
          .map((e) => DeviceConditionData.fromJson(e))
          .toList(),
      devicesPerBranch: (json['devicesPerBranch'] as List<dynamic>? ?? [])
          .map((e) => DevicesPerBranchData.fromJson(e))
          .toList(),
    );
  }
}

class DeviceConditionData {
  final String condition;
  final int count;

  DeviceConditionData({required this.condition, required this.count});

  factory DeviceConditionData.fromJson(Map<String, dynamic> json) {
    return DeviceConditionData(
      condition: json['condition'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class DevicesPerBranchData {
  final String branchName;
  final int count;

  DevicesPerBranchData({required this.branchName, required this.count});

  factory DevicesPerBranchData.fromJson(Map<String, dynamic> json) {
    return DevicesPerBranchData(
      branchName: json['branchName'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
