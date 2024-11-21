import 'package:dissau_automatic/src/pages/auth/login_page.dart';
import 'package:dissau_automatic/src/pages/auth/register_page.dart';

import 'package:dissau_automatic/src/routes/app_navigation.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRutas() {
  return <String, WidgetBuilder>{
    "login": (BuildContext context) => LoginPage(),
    "register": (BuildContext context) => const RegisterPage(),
    "sms": (BuildContext context) => AppNavigation(),
  };
}
