class ProfileModel {
  final String? name;
  final String? pn;
  final String? department;
  final String? branch;
  final String? position;

  ProfileModel({
    this.name,
    this.pn,
    this.department,
    this.branch,
    this.position,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print('Parsing profile JSON: $json'); // Log untuk debugging
    return ProfileModel(
      name: json['name'] as String? ?? 'Unknown',
      pn: json['pn'] as String? ?? '',
      department: json['department'] as String? ?? 'Unknown',
      branch: json['branch'] as String? ?? 'Unknown',
      position: json['position'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pn': pn,
      'department': department,
      'branch': branch,
      'position': position,
    };
  }
}
