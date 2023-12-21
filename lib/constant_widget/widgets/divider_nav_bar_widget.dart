import 'package:flutter/material.dart';

class DividerNavBarWidget extends StatelessWidget {
  const DividerNavBarWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 3,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
