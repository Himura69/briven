class FormOption {
  final int id;
  final String label;

  FormOption({
    required this.id,
    required this.label,
  });

  factory FormOption.fromJson(Map<String, dynamic> json) {
    int? id = json['device_id'] ??
        json['deviceId'] ?? // ✅ tambahkan ini
        json['user_id'] ??
        json['userId'] ?? // opsional, untuk konsistensi
        json['branch_id'] ??
        json['branchId'] ?? // opsional, untuk konsistensi
        json['department_id'];

    if (id == null) {
      throw Exception('Unknown option ID field in form option: $json');
    }

    return FormOption(
      id: id,
      label: json['label'] ?? json['assetCode'] ?? '', // optional fallback
    );
  }

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;
}
