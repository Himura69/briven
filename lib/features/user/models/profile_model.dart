class ProfileModel {
  final String name;
  final String pn;
  final String department;
  final String branch;
  final String position;

  ProfileModel({
    required this.name,
    required this.pn,
    required this.department,
    required this.branch,
    required this.position,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      pn: json['pn'] as String,
      department: json['department'] as String,
      branch: json['branch'] as String,
      position: json['position'] as String,
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
