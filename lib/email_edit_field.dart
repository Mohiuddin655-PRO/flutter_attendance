import 'package:flutter/material.dart';

class EmailEditField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? initialValue;

  const EmailEditField({
    super.key,
    required this.controller,
    this.hintText,
    this.initialValue,
  });

  @override
  State<EmailEditField> createState() => _EmailEditFieldState();
}

class _EmailEditFieldState extends State<EmailEditField> {
  @override
  void initState() {
    widget.controller.text = widget.initialValue ?? widget.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(),
        border: const UnderlineInputBorder(),
        hintText: widget.hintText,
      ),
    );
  }
}
