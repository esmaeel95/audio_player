import 'package:audio_player/constant_widget/widgets/divider_nav_bar_widget.dart';
import 'package:flutter/material.dart';

class CustomComponentNavBarWidget extends StatelessWidget {
  const CustomComponentNavBarWidget(
      {super.key, this.onTap, required this.icon, required this.color});

  final void Function()? onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10),
              child: Icon(icon, color: Colors.grey, size: 35),
            ),
            DividerNavBarWidget(
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
