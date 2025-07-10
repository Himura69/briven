import 'package:get/get.dart';

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['data']['token'],
      user: User.fromJson(json['data']['user']),
    );
  }
}

class User {
  final int userId;
  final String name;
  final String pn;
  final String role;

  User({
    required this.userId,
    required this.name,
    required this.pn,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      pn: json['pn'],
      role: json['role'],
    );
  }
}
