import 'package:dissau_automatic/src/pages/sms_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_2/src/pages/counter_page.dart';

//import 'package:flutter_application_2/src/pages/home_pages.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Center(
          //child: HomePage(),
          child: SmsPage(),
        ));
  }
}
