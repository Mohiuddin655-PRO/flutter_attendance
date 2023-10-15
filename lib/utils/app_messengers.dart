import 'package:flutter/material.dart';

class Messengers {
  final BuildContext context;

  const Messengers._(this.context);

  const Messengers.of(BuildContext context) : this._(context);

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
