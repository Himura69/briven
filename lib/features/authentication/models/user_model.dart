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
    print('Parsing user JSON: $json'); // Log respons JSON
    final userData = json['user'] as Map<String, dynamic>? ??
        json; // Menangani jika ada nested 'user'
    return UserModel(
      userId: userData['userId'] as int? ?? 0,
      name: userData['name'] as String? ?? 'Unknown',
      pn: userData['pn'] as String? ?? '',
      role: userData['role'] as String? ?? 'User',
      token:
          json['token'] as String? ?? '', // Pastikan token diambil dari 'token'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'pn': pn,
      'role': role,
      'token': token,
    };
  }
}
