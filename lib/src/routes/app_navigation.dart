import 'package:dissau_automatic/src/pages/main/home_page.dart';
import 'package:dissau_automatic/src/pages/products/products_page.dart';
import 'package:dissau_automatic/src/pages/profile/profile_page.dart';
import 'package:dissau_automatic/src/pages/main/settings_page.dart';
import 'package:dissau_automatic/src/widgets/custom_bar_navigation.dart';

import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomePage(),
    //   const ProductsPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
