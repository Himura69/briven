class AdminAssignmentModel {
  final int assignmentId;
  final int? deviceId;
  final String assetCode;
  final String brand;
  final String brandName;
  final String serialNumber;
  final String assignedTo;
  final String unitName;
  final String? status;
  final String assignedDate;
  final String? returnedDate;
  final String? notes;
  final List<AssignmentLetter> assignmentLetters;

  AdminAssignmentModel({
    required this.assignmentId,
    this.deviceId,
    required this.assetCode,
    required this.brand,
    required this.brandName,
    required this.serialNumber,
    required this.assignedTo,
    required this.unitName,
    this.status,
    required this.assignedDate,
    this.returnedDate,
    this.notes,
    this.assignmentLetters = const [],
  });

  factory AdminAssignmentModel.fromJson(Map<String, dynamic> json) {
    return AdminAssignmentModel(
      assignmentId: json['assignmentId'] ?? 0,
      deviceId: json['deviceId'],
      assetCode: json['assetCode'] ?? '',
      brand: json['brand'] ?? '',
      brandName: json['brandName'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      unitName: json['unitName'] ?? '',
      status: json['status'],
      assignedDate: json['assignedDate'] ?? '',
      returnedDate: json['returnedDate'],
      notes: json['notes'],
      assignmentLetters: (json['assignmentLetters'] as List<dynamic>? ?? [])
          .map((e) => AssignmentLetter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'deviceId': deviceId,
      'assetCode': assetCode,
      'brand': brand,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'assignedTo': assignedTo,
      'unitName': unitName,
      'status': status,
      'assignedDate': assignedDate,
      'returnedDate': returnedDate,
      'notes': notes,
      'assignmentLetters': assignmentLetters.map((e) => e.toJson()).toList(),
    };
  }
}

class AssignmentLetter {
  final int assignmentLetterId;
  final String assignmentType;
  final String letterNumber;
  final String letterDate;
  final String fileUrl;

  AssignmentLetter({
    required this.assignmentLetterId,
    required this.assignmentType,
    required this.letterNumber,
    required this.letterDate,
    required this.fileUrl,
  });

  factory AssignmentLetter.fromJson(Map<String, dynamic> json) {
    return AssignmentLetter(
      assignmentLetterId: json['assignmentLetterId'] ?? 0,
      assignmentType: json['assignmentType'] ?? '',
      letterNumber: json['letterNumber'] ?? '',
      letterDate: json['letterDate'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentLetterId': assignmentLetterId,
      'assignmentType': assignmentType,
      'letterNumber': letterNumber,
      'letterDate': letterDate,
      'fileUrl': fileUrl,
    };
  }
}
