class UserProfile {
  final String name;
  final String pn;
  final String department;
  final String branch;
  final String position;

  UserProfile({
    required this.name,
    required this.pn,
    required this.department,
    required this.branch,
    required this.position,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      pn: json['pn'],
      department: json['department'],
      branch: json['branch'],
      position: json['position'],
    );
  }
}
