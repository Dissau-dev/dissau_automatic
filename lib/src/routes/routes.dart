import 'package:dissau_automatic/src/pages/auth/login_page.dart';
import 'package:dissau_automatic/src/pages/auth/register_page.dart';
import 'package:dissau_automatic/src/pages/main/home_page.dart';
import 'package:dissau_automatic/src/routes/app_navigation.dart';
import 'package:dissau_automatic/src/routes/auth_navigation.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRutas() {
  return <String, WidgetBuilder>{
    '/login': (context) => LoginPage(),
    '/register': (context) => RegisterPage(),
    '/home': (context) => AppNavigation(),
  };
}
