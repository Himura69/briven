class ScannedQrResult {
  final ScannedDevice device;
  final List<AssignmentHistory> history;

  ScannedQrResult({required this.device, required this.history});

  factory ScannedQrResult.fromJson(Map<String, dynamic> json) {
    return ScannedQrResult(
      device: ScannedDevice.fromJson(json['device']),
      history: (json['history'] as List<dynamic>)
          .map((e) => AssignmentHistory.fromJson(e))
          .toList(),
    );
  }
}

class ScannedDevice {
  final String name;
  final String type;
  final String serialNumber;
  final String status;
  final String condition;
  final String spec1;
  final String spec2;
  final String spec3;
  final String spec4;
  final String spec5;
  final AssignedUser? assignedTo;

  ScannedDevice({
    required this.name,
    required this.type,
    required this.serialNumber,
    required this.status,
    required this.condition,
    required this.spec1,
    required this.spec2,
    required this.spec3,
    required this.spec4,
    required this.spec5,
    this.assignedTo,
  });

  factory ScannedDevice.fromJson(Map<String, dynamic> json) {
    return ScannedDevice(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      status: json['status'] ?? '',
      condition: json['condition'] ?? '',
      spec1: json['spec_1'] ?? '',
      spec2: json['spec_2'] ?? '',
      spec3: json['spec_3'] ?? '',
      spec4: json['spec_4'] ?? '',
      spec5: json['spec_5'] ?? '',
      assignedTo: json['assigned_to'] != null
          ? AssignedUser.fromJson(json['assigned_to'])
          : null,
    );
  }
}

class AssignedUser {
  final String name;
  final String pn;
  final String department;
  final String position;
  final String branch;

  AssignedUser({
    required this.name,
    required this.pn,
    required this.department,
    required this.position,
    required this.branch,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      name: json['name'] ?? '',
      pn: json['pn'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      branch: json['branch'] ?? '',
    );
  }
}

class AssignmentHistory {
  final String action;
  final String user;
  final String date;
  final String approver;
  final String note;

  AssignmentHistory({
    required this.action,
    required this.user,
    required this.date,
    required this.approver,
    required this.note,
  });

  factory AssignmentHistory.fromJson(Map<String, dynamic> json) {
    return AssignmentHistory(
      action: json['action'] ?? '',
      user: json['user'] ?? '',
      date: json['date'] ?? '',
      approver: json['approver'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
