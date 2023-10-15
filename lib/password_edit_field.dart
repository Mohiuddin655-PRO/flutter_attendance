import 'package:flutter/material.dart';

class PasswordEditField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? initialValue;

  const PasswordEditField({
    super.key,
    required this.controller,
    this.hintText,
    this.initialValue,
  });

  @override
  State<PasswordEditField> createState() => _PasswordEditFieldState();
}

class _PasswordEditFieldState extends State<PasswordEditField> {
  @override
  void initState() {
    widget.controller.text = widget.initialValue ?? widget.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(),
        border: const UnderlineInputBorder(),
        hintText: widget.hintText,
      ),
    );
  }
}
