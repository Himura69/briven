import 'dart:convert';

class UserModel {
  final String token;
  final String name;
  final String? role;

  UserModel({
    required this.token,
    required this.name,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '', // Token di level user jika ada
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
      'role': role,
    };
  }
}