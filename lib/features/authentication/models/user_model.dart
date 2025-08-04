class UserModel {
  final int? id;
  final String token;
  final String name;
  final String? role;

  UserModel({
    this.id,
    required this.token,
    required this.name,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'name': name,
      'role': role,
    };
  }
}
