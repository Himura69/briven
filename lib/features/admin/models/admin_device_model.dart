class AdminDeviceModel {
  final int deviceId;
  final String assetCode;
  final String brand;
  final String brandName;
  final String serialNumber;
  final String condition;
  final String category;
  final String? spec1;
  final String? spec2;
  final String? spec3;
  final String? spec4;
  final String? spec5;
  final bool isAssigned;
  final String? assignedTo;
  final String? assignedDate;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  AdminDeviceModel({
    required this.deviceId,
    required this.assetCode,
    required this.brand,
    required this.brandName,
    required this.serialNumber,
    required this.condition,
    required this.category,
    this.spec1,
    this.spec2,
    this.spec3,
    this.spec4,
    this.spec5,
    required this.isAssigned,
    this.assignedTo,
    this.assignedDate,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory AdminDeviceModel.fromJson(Map<String, dynamic> json) {
    return AdminDeviceModel(
      deviceId: json['deviceId'] ?? 0,
      assetCode: json['assetCode'] ?? '',
      brand: json['brand'] ?? '',
      brandName: json['brandName'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      condition: json['condition'] ?? '',
      category: json['category'] ?? '',
      spec1: json['spec1'],
      spec2: json['spec2'],
      spec3: json['spec3'],
      spec4: json['spec4'],
      spec5: json['spec5'],
      isAssigned: json['isAssigned'] ?? false,
      assignedTo: json['assignedTo'],
      assignedDate: json['assignedDate'],
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'assetCode': assetCode,
      'brand': brand,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'condition': condition,
      'category': category,
      'spec1': spec1,
      'spec2': spec2,
      'spec3': spec3,
      'spec4': spec4,
      'spec5': spec5,
      'isAssigned': isAssigned,
      'assignedTo': assignedTo,
      'assignedDate': assignedDate,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
    };
  }
}
