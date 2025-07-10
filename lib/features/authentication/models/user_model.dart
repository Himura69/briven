class UserModel {
  final int userId;
  final String name;
  final String pn;
  final String role;
  final String token;

  UserModel({
    required this.userId,
    required this.name,
    required this.pn,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user']['userId'] as int,
      name: json['user']['name'] as String,
      pn: json['user']['pn'] as String,
      role: json['user']['role'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'userId': userId,
        'name': name,
        'pn': pn,
        'role': role,
      },
      'token': token,
    };
  }
}
