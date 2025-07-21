class AdminDeviceModel {
  final int deviceId;
  final String brand;
  final String serialNumber;
  final String condition;

  AdminDeviceModel({
    required this.deviceId,
    required this.brand,
    required this.serialNumber,
    required this.condition,
  });

  factory AdminDeviceModel.fromJson(Map<String, dynamic> json) {
    return AdminDeviceModel(
      deviceId: json['deviceId'] ?? 0,
      brand: json['brand'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      condition: json['condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'brand': brand,
      'serialNumber': serialNumber,
      'condition': condition,
    };
  }
}
