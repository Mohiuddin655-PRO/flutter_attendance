import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_attendence/main.dart';
import 'package:flutter_attendence/primary_button.dart';
import 'package:flutter_attendence/sign_in/auth_sign_in.dart';
import 'package:flutter_attendence/user.dart';
import 'package:flutter_attendence/utils/api_helpers.dart';
import 'package:flutter_attendence/utils/app_messengers.dart';
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Messengers messengers;
  late GeolocatorPlatform geoLocator;

  bool loading = false;
  late User user;

  Future<Position?> _getPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      return null;
    }
    return geoLocator.getCurrentPosition();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await geoLocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await geoLocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geoLocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    messengers = Messengers.of(context);
    geoLocator = GeolocatorPlatform.instance;
    user = getUser();
    _checkUser();
    super.initState();
  }

  User getUser() {
    final raw = preferences.getString("user") ?? "{}";
    return User.from(jsonDecode(raw));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Work End",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Visibility(
              visible: user.accessToken != null,
              child: PrimaryButton(
                text: "FINISH NOW",
                loading: loading,
                width: 180,
                onPressed: _onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkUser() async {
    final response = await AuthHelpers.check(
      token: user.accessToken ?? "",
    );
    if (response.isLeft()) {
      _next(const AuthSignIn(), true);
    }
  }

  void _onLogout() async {
    final currentEmployee = await AuthHelpers.checkBio();
    if (currentEmployee.isRight()){
      if (user.accessToken != null) {
        setState(() => loading = true);
        final position = await _getPosition();
        if (position != null) {
          final data = await AuthHelpers.signOut(
            token: user.accessToken ?? "",
            position: position,
          );
          messengers.showSnackBar(
            data.isRight() ? "Logout successfully!" : "Logout unsuccessfully!",
          );
          if (data.isRight()) {
            _next(const AuthSignIn(), true);
          }
        }
        setState(() => loading = false);
      } else {
        messengers.showSnackBar("Token isn't valid!");
      }
    } else {
      messengers.showSnackBar("Biometric not matched!");
    }
  }

  void _next(Widget child, [bool clearMode = false]) {
    if (clearMode) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return child;
          },
        ),
            (route) => false,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return child;
          },
        ),
      );
    }
  }
}
