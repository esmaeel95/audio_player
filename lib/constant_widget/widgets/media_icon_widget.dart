import 'package:flutter/material.dart';

class CustomMediaIconWidget extends StatelessWidget {
  const CustomMediaIconWidget({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: 40,
    );
  }
}
