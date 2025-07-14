class LoanHistoryModel {
  final String? deviceName;
  final String? serialNumber;
  final String? assignedDate;
  final String? returnedDate;

  LoanHistoryModel({
    this.deviceName,
    this.serialNumber,
    this.assignedDate,
    this.returnedDate,
  });

  factory LoanHistoryModel.fromJson(Map<String, dynamic> json) {
    print('Parsing loan history JSON: $json');
    return LoanHistoryModel(
      deviceName: json['deviceName'] as String?,
      serialNumber: json['serialNumber'] as String?,
      assignedDate: json['assignedDate'] as String?,
      returnedDate: json['returnedDate'] as String?,
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
      currentPage: json['currentPage'] as int? ?? 1,
      lastPage: json['lastPage'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
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