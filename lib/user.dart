import 'dart:convert';

import 'package:flutter_andomie/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String? accessToken;
  final String? accessTokenExpiresAt;
  final String? refreshToken;
  final String? refreshTokenExpiresAt;
  final String? client;
  final String? userid;
  final String? email;

  const User({
    this.accessToken,
    this.accessTokenExpiresAt,
    this.refreshToken,
    this.refreshTokenExpiresAt,
    this.client,
    this.userid,
    this.email,
  });

  factory User.fromPreferences(SharedPreferences preferences) {
    final raw = preferences.getString("user");
    final data = jsonDecode(raw ?? "{}");
    return User.from(data ?? {});
  }

  factory User.from(Map<String, dynamic> source) {
    final user = source.getValue("user") as Map<String, dynamic>?;
    return User(
      accessToken: source.getValue("accessToken"),
      accessTokenExpiresAt: source.getValue("accessTokenExpiresAt"),
      refreshToken: source.getValue("refreshToken"),
      refreshTokenExpiresAt: source.getValue("refreshTokenExpiresAt"),
      client: source.getValue("client"),
      userid: source.getValue("userid"),
      email: user.getValue("email"),
    );
  }

  Map<String, dynamic> get source {
    return {
      "accessToken": accessToken,
      "accessTokenExpiresAt": accessTokenExpiresAt,
      "refreshToken": refreshToken,
      "refreshTokenExpiresAt": refreshTokenExpiresAt,
      "client": client,
      "user": {"email": email},
      "userid": userid
    };
  }
}
