import 'package:flutter/material.dart';
import 'package:dissau_automatic/src/pages/auth/login_page.dart';
import 'package:dissau_automatic/src/pages/auth/register_page.dart';

class AuthNavigation extends StatelessWidget {
  const AuthNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/auth/login', // Ruta inicial para login
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/auth/login':
            builder = (BuildContext _) => LoginPage();
            break;
          case '/auth/register':
            builder = (BuildContext _) => RegisterPage();
            break;
          default:
            builder = (BuildContext _) => LoginPage(); // Ruta predeterminada
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
