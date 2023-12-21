import 'package:flutter/material.dart';

class HeadphonesIconWidget extends StatelessWidget {
  const HeadphonesIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          shape: BoxShape.circle,
        ),
        width: 45,
        height: 45,
        child: const Icon(
          Icons.headphones_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
