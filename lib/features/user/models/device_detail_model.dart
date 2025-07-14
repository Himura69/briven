class DeviceDetailModel {
  final int? deviceId;
  final String? brand;
  final String? serialNumber;
  final String? assetCode;
  final String? assignedDate;
  final String? spec1;
  final String? spec2;
  final String? spec3;
  final String? spec4;
  final String? spec5;

  DeviceDetailModel({
    this.deviceId,
    this.brand,
    this.serialNumber,
    this.assetCode,
    this.assignedDate,
    this.spec1,
    this.spec2,
    this.spec3,
    this.spec4,
    this.spec5,
  });

  factory DeviceDetailModel.fromJson(Map<String, dynamic> json) {
    print('Parsing device detail JSON: $json');
    final deviceData = json['data'] as Map<String, dynamic>? ?? json;
    return DeviceDetailModel(
      deviceId: deviceData['deviceId'] as int? ?? 0,
      brand: deviceData['brand'] as String? ?? 'Unknown Brand',
      serialNumber: deviceData['serialNumber'] as String? ?? 'Unknown Serial',
      assetCode: deviceData['assetCode'] as String? ?? 'Unknown Asset Code',
      assignedDate: deviceData['assignedDate'] as String? ?? 'Unknown Date',
      spec1: deviceData['spec1'] as String? ?? 'Not Specified',
      spec2: deviceData['spec2'] as String? ?? 'Not Specified',
      spec3: deviceData['spec3'] as String? ?? 'Not Specified',
      spec4: deviceData['spec4'] as String? ?? 'Not Specified',
      spec5: deviceData['spec5'] as String? ?? 'Not Specified',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'brand': brand,
      'serialNumber': serialNumber,
      'assetCode': assetCode,
      'assignedDate': assignedDate,
      'spec1': spec1,
      'spec2': spec2,
      'spec3': spec3,
      'spec4': spec4,
      'spec5': spec5,
    };
  }
}