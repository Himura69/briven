class AdminAssignmentDetailModel {
  final int assignmentId;
  final int deviceId;
  final String assetCode;
  final String brand;
  final String brandName;
  final String serialNumber;
  final String assignedTo;
  final String unitName;
  final String assignedDate;
  final String? returnedDate;
  final String? status;
  final String? notes;
  final List<AssignmentLetter> assignmentLetters;

  AdminAssignmentDetailModel({
    required this.assignmentId,
    required this.deviceId,
    required this.assetCode,
    required this.brand,
    required this.brandName,
    required this.serialNumber,
    required this.assignedTo,
    required this.unitName,
    required this.assignedDate,
    this.returnedDate,
    this.status,
    this.notes,
    this.assignmentLetters = const [],
  });

  factory AdminAssignmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AdminAssignmentDetailModel(
      assignmentId: json['assignmentId'] ?? 0,
      deviceId: json['deviceId'] ?? 0,
      assetCode: json['assetCode'] ?? '',
      brand: json['brand'] ?? '',
      brandName: json['brandName'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      unitName: json['unitName'] ?? '',
      assignedDate: json['assignedDate'] ?? '',
      returnedDate: json['returnedDate'],
      status: json['status'],
      notes: json['notes'],
      assignmentLetters: (json['assignmentLetters'] as List<dynamic>? ?? [])
          .map((e) => AssignmentLetter.fromJson(e))
          .toList(),
    );
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
}
