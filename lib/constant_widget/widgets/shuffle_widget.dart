import 'package:flutter/material.dart';

class ShuffleWidget extends StatelessWidget {
  const ShuffleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.7,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Colors.pinkAccent, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shuffle,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 5),
          Text(
            'Shuffle play',
            style:
                TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
