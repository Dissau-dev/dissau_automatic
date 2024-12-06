import 'package:flutter/material.dart';

class Baner extends StatelessWidget {
  const Baner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Image.asset('assets/images/Baner.png', height: 200, width: 600),
    );
  }
}
