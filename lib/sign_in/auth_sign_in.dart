import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_attendence/dashboard/dashboard.dart';
import 'package:flutter_attendence/email_edit_field.dart';
import 'package:flutter_attendence/password_edit_field.dart';
import 'package:flutter_attendence/primary_button.dart';
import 'package:flutter_attendence/secondary_button.dart';
import 'package:flutter_attendence/sign_up/auth_sign_up.dart';
import 'package:flutter_attendence/utils/app_messengers.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/api_helpers.dart';

class AuthSignIn extends StatefulWidget {
  const AuthSignIn({
    super.key,
  });

  @override
  State<AuthSignIn> createState() => _AuthSignInState();
}

class _AuthSignInState extends State<AuthSignIn> {
  late Messengers messengers;
  late TextEditingController etEmail, etPassword;
  late GeolocatorPlatform geoLocator;

  bool loading = false;

  @override
  void initState() {
    messengers = Messengers.of(context);
    geoLocator = GeolocatorPlatform.instance;
    etEmail = TextEditingController();
    etPassword = TextEditingController();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Work Start",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 54,
            ),
            EmailEditField(
              initialValue: "example@gmail.com",
              controller: etEmail,
              hintText: "Enter your official email",
            ),
            const SizedBox(
              height: 24,
            ),
            PasswordEditField(
              initialValue: "123456",
              controller: etPassword,
              hintText: "Enter the password",
            ),
            const SizedBox(
              height: 24,
            ),
            PrimaryButton(
              text: "START NOW",
              loading: loading,
              onPressed: _onLoginCheck,
            ),
            const SizedBox(
              height: 24,
            ),
            SecondaryButton(
              text: "Create a new employee account",
              onPressed: () => _next(const AuthSignUp()),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginCheck() async {
    String email = etEmail.text;
    String password = etPassword.text;

    if (!Validator.isValidEmail(email)) {
      messengers.showSnackBar(
        "Email isn't valid, please enter the valid email!",
      );
      return;
    }
    if (!Validator.isValidPassword(password, 6)) {
      messengers.showSnackBar(
        "Password isn't valid, please enter the valid password!",
      );
      return;
    }
    _onLogin(email, password);
  }

  void _onLogin(String email, String password) async {
    setState(() => loading = true);
    final position = await _getPosition();
    if (position != null) {
      var data = await AuthHelpers.signIn(
        email: email,
        password: password,
        position: position,
      );
      messengers.showSnackBar(
        data.isRight() ? "Login successfully!" : "Login unsuccessfully!",
      );
      if (data.isRight()) {
        _next(const Dashboard(), true);
      } else {
        setState(() => loading = false);
      }
    } else {
      messengers.showSnackBar("Something wrong, please try again!");
      setState(() => loading = false);
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
