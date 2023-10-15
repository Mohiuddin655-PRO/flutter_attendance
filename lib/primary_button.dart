import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool loading;
  final double? width;
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    this.width,
    this.loading = false,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return Theme.of(context).colorScheme.primary;
          }),
        ),
        child: loading
            ? Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(6),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
