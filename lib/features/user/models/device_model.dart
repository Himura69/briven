class DeviceModel {
  final int? deviceId;
  final String? categoryName;
  final String? brand;
  final String? serialNumber;
  final int? assignmentId;

  DeviceModel({
    this.deviceId,
    this.categoryName,
    this.brand,
    this.serialNumber,
    this.assignmentId,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    print('Parsing device JSON: $json'); // Log JSON mentah
    // Menangani struktur nested 'device' atau flat
    final deviceData = json['device'] as Map<String, dynamic>? ?? json;
    // Mencoba berbagai nama field untuk kategori
    final category = deviceData['categoryName'] as String? ??
        deviceData['category'] as String? ??
        deviceData['deviceCategory'] as String? ??
        deviceData['type'] as String? ??
        deviceData['deviceType'] as String? ??
        'Unknown Category';
    print('Field kategori yang ditemukan: $category'); // Log field kategori
    return DeviceModel(
      deviceId: deviceData['deviceId'] as int? ?? 0,
      categoryName: category,
      brand: deviceData['brand'] as String? ?? 'Unknown Brand',
      serialNumber: deviceData['serialNumber'] as String? ?? 'Unknown Serial',
      assignmentId: json['assignmentId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'categoryName': categoryName,
      'brand': brand,
      'serialNumber': serialNumber,
      'assignmentId': assignmentId,
    };
  }
}
