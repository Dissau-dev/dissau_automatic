import 'package:flutter/material.dart';

class Baner extends StatelessWidget {
  const Baner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepPurple.shade100,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Artificial Intelligence",
            style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Best Offers",
            style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Up to 30% off",
            style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.purple.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
