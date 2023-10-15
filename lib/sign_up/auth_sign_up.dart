import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_attendence/email_edit_field.dart';
import 'package:flutter_attendence/password_edit_field.dart';
import 'package:flutter_attendence/primary_button.dart';
import 'package:flutter_attendence/utils/app_messengers.dart';

import '../utils/api_helpers.dart';

class AuthSignUp extends StatefulWidget {
  const AuthSignUp({
    super.key,
  });

  @override
  State<AuthSignUp> createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {
  late Messengers messengers;
  late TextEditingController etEmail, etPassword;

  bool loading = false;

  @override
  void initState() {
    messengers = Messengers.of(context);
    etEmail = TextEditingController();
    etPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign up"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 54,
              ),
              EmailEditField(
                controller: etEmail,
                hintText: "Enter the email",
              ),
              const SizedBox(
                height: 24,
              ),
              PasswordEditField(
                controller: etPassword,
                hintText: "Enter the password",
              ),
              const SizedBox(
                height: 24,
              ),
              PrimaryButton(
                text: "Submit",
                loading: loading,
                onPressed: _onLoginCheck,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => _next(),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginCheck() {
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
    _onRegister(email, password);
  }

  void _onRegister(String email, String password) async {
    setState(() => loading = true);
    var data = await AuthHelpers.signUp(
      email: email,
      password: password,
    );
    messengers.showSnackBar(
      data.isRight() ? "Register successfully!" : "Register unsuccessfully!",
    );
    setState(() => loading = false);
    if (data.isRight()) {
      _next();
    }
  }

  void _next([Widget? child]) {
    if (child != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return child;
          },
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
