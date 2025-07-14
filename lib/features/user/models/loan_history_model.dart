class LoanHistoryModel {
  final String deviceName;
  final String serialNumber;
  final String assignedDate;
  final String? returnedDate;

  LoanHistoryModel({
    required this.deviceName,
    required this.serialNumber,
    required this.assignedDate,
    this.returnedDate,
  });

  factory LoanHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoanHistoryModel(
      deviceName: json['deviceName'] ?? 'Unknown',
      serialNumber: json['serialNumber'] ?? 'Unknown',
      assignedDate: json['assignedDate'] ?? 'Unknown',
      returnedDate: json['returnedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceName': deviceName,
      'serialNumber': serialNumber,
      'assignedDate': assignedDate,
      'returnedDate': returnedDate,
    };
  }
}

class LoanHistoryMeta {
  final int currentPage;
  final int lastPage;
  final int total;

  LoanHistoryMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory LoanHistoryMeta.fromJson(Map<String, dynamic> json) {
    return LoanHistoryMeta(
      currentPage: json['currentPage'] ?? 1,
      lastPage: json['lastPage'] ?? 1,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'lastPage': lastPage,
      'total': total,
    };
  }
}
