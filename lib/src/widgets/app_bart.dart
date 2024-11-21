import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff25253a),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
