import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_attendence/main.dart';
import 'package:flutter_attendence/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LocalAuthentication _localAuthentication = LocalAuthentication();

typedef AuthResponse<T extends AuthData> = Future<Either<AuthFailure, T>>;

class AuthHelpers {
  static const String baseUrl = "http://147.182.180.252:50100/auth/";

  static Uri _uri(String api) => Uri.parse("$baseUrl$api");

  static AuthResponse check({
    required String token,
  }) async {
    try {
      final response = await get(
        _uri("authcheck"),
        headers: {
          "authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return const Right(AuthData());
      } else {
        return const Left(AuthFailure(
          "Unauthorized",
          error: "Access denied",
          statusCode: 401,
        ));
      }
    } catch (_) {
      return Left(AuthFailure(
        _.toString(),
      ));
    }
  }

  static AuthResponse checkBio() async {
    try {
      if (!await _localAuthentication.isDeviceSupported()) {
        return Future.error('Device is not supported!');
      } else {
        if (await _localAuthentication.canCheckBiometrics) {
          final authenticated = await _localAuthentication.authenticate(
            localizedReason:
                'Scan your fingerprint (or face or whatever) to authenticate',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: false,
            ),
          );
          if (authenticated) {
            return const Right(AuthData(data: true));
          } else {
            return const Left(AuthFailure("Biometric matching failed!"));
          }
        } else {
          return const Left(AuthFailure("Can not check biometrics"));
        }
      }
    } catch (e) {
      return const Left(AuthFailure("Device is not supported!"));
    }
  }

  static AuthResponse signIn({
    required String email,
    required String password,
    required Position position,
  }) async {
    try {
      final response = await post(
        _uri("login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "authorization": "application:secret",
          "grant_type": "password",
          "email": email,
          "password": password,
          "position": {
            "lat": "${position.latitude}",
            "long": "${position.longitude}",
          }
        }),
      );

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body) as Map;
        final data = raw["encoded"]["data"];
        final user = User.from(data);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("user", jsonEncode(user.source));
        return Right(AuthData(data: user));
      } else {
        return const Left(AuthFailure(
          "Unauthorized",
          error: "User not found!",
          statusCode: 401,
        ));
      }
    } catch (_) {
      return Left(AuthFailure(_.toString()));
    }
  }

  static AuthResponse signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await post(
        _uri("signup"),
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        return const Right(AuthData());
      } else {
        return const Left(AuthFailure(
          "Conflict",
          error: "Already exists!",
          statusCode: 409,
        ));
      }
    } catch (_) {
      return Left(AuthFailure(
        _.toString(),
      ));
    }
  }

  static AuthResponse signOut({
    required String token,
    required Position position,
  }) async {
    try {
      final response = await post(
        _uri("logout"),
        headers: {
          "authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "position": {
            "lat": "${position.latitude}",
            "long": "${position.longitude}",
          }
        }),
      );

      if (response.statusCode == 200) {
        preferences.setString("user", "{}");
        return const Right(AuthData());
      } else {
        return const Left(AuthFailure(
          "Conflict",
          error: "Already exists!",
          statusCode: 409,
        ));
      }
    } catch (_) {
      return Left(AuthFailure(
        _.toString(),
      ));
    }
  }
}

class AuthData<T> {
  final T? data;

  const AuthData({
    this.data,
  });
}

class AuthFailure {
  final String message;
  final String error;
  final int statusCode;

  const AuthFailure(
    this.message, {
    this.error = "",
    this.statusCode = 0,
  });
}
