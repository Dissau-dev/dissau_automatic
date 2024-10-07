import 'package:dissau_automatic/src/pages/login_page.dart';
import 'package:dissau_automatic/src/pages/register_page.dart';
import 'package:dissau_automatic/src/pages/sms_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRutas() {
  return <String, WidgetBuilder>{
    "login": (BuildContext context) => LoginPage(),
    "register": (BuildContext context) => RegisterPage(),
    "sms": (BuildContext context) => SmsPage(),
  };
}
