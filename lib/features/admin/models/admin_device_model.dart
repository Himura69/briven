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
  final String? devDate; // <-- Tambahan

  final CurrentAssignment? currentAssignment;
  final List<AssignmentHistory> assignmentHistory;

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
    this.isAssigned = false,
    this.assignedTo,
    this.assignedDate,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.devDate, // <-- Tambahan
    this.currentAssignment,
    this.assignmentHistory = const [],
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
      devDate: json['devDate'], // <-- Tambahan
      currentAssignment: json['currentAssignment'] != null
          ? CurrentAssignment.fromJson(json['currentAssignment'])
          : null,
      assignmentHistory: (json['assignmentHistory'] as List<dynamic>?)
              ?.map((e) => AssignmentHistory.fromJson(e))
              .toList() ??
          [],
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
      'devDate': devDate, // <-- Tambahan
      'currentAssignment': currentAssignment?.toJson(),
      'assignmentHistory': assignmentHistory.map((e) => e.toJson()).toList(),
    };
  }
}

class CurrentAssignment {
  final int assignmentId;
  final UserSummary user;
  final BranchSummary branch;
  final String assignedDate;
  final String status;
  final String? notes;

  CurrentAssignment({
    required this.assignmentId,
    required this.user,
    required this.branch,
    required this.assignedDate,
    required this.status,
    this.notes,
  });

  factory CurrentAssignment.fromJson(Map<String, dynamic> json) {
    return CurrentAssignment(
      assignmentId: json['assignmentId'] ?? 0,
      user: UserSummary.fromJson(json['user'] ?? {}),
      branch: BranchSummary.fromJson(json['branch'] ?? {}),
      assignedDate: json['assignedDate'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'user': user.toJson(),
      'branch': branch.toJson(),
      'assignedDate': assignedDate,
      'status': status,
      'notes': notes,
    };
  }
}

class AssignmentHistory {
  final int assignmentId;
  final String userName;
  final String userPn;
  final String assignedDate;
  final String? returnedDate;
  final String status;
  final String? notes;

  AssignmentHistory({
    required this.assignmentId,
    required this.userName,
    required this.userPn,
    required this.assignedDate,
    this.returnedDate,
    required this.status,
    this.notes,
  });

  factory AssignmentHistory.fromJson(Map<String, dynamic> json) {
    return AssignmentHistory(
      assignmentId: json['assignmentId'] ?? 0,
      userName: json['userName'] ?? '',
      userPn: json['userPn'] ?? '',
      assignedDate: json['assignedDate'] ?? '',
      returnedDate: json['returnedDate'],
      status: json['status'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'userName': userName,
      'userPn': userPn,
      'assignedDate': assignedDate,
      'returnedDate': returnedDate,
      'status': status,
      'notes': notes,
    };
  }
}

class UserSummary {
  final int userId;
  final String name;
  final String pn;
  final String position;

  UserSummary({
    required this.userId,
    required this.name,
    required this.pn,
    required this.position,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      pn: json['pn'] ?? '',
      position: json['position'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'pn': pn,
      'position': position,
    };
  }
}

class BranchSummary {
  final int branchId;
  final String unitName;
  final String branchCode;

  BranchSummary({
    required this.branchId,
    required this.unitName,
    required this.branchCode,
  });

  factory BranchSummary.fromJson(Map<String, dynamic> json) {
    return BranchSummary(
      branchId: json['branchId'] ?? 0,
      unitName: json['unitName'] ?? '',
      branchCode: json['branchCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'unitName': unitName,
      'branchCode': branchCode,
    };
  }
}
