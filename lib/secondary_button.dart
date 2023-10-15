import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final bool loading;
  final String text;
  final double? width;
  final VoidCallback? onPressed;

  const SecondaryButton({
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
