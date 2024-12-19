import 'package:dissau_automatic/src/pages/profile/account_page.dart';
import 'package:dissau_automatic/src/pages/profile/payment_page.dart';
import 'package:dissau_automatic/src/pages/profile/profile_page.dart';
import 'package:dissau_automatic/src/pages/profile/subscription_page.dart';
import 'package:dissau_automatic/src/pages/profile/subscription_page.dart';
import 'package:flutter/material.dart';

class ProfileNavigation extends StatelessWidget {
  const ProfileNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/profile/home', // Ruta inicial
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        // Define las rutas internas del perfil
        switch (settings.name) {
          case '/profile/home':
            builder = (BuildContext _) => const ProfilePage();
            break;
          case '/profile/account':
            builder = (BuildContext _) => const AccountPage();
            break;
          case '/profile/subs':
            builder = (BuildContext _) => const SubscriptionPage();
            break;
          case '/profile/payment':
            // Aquí pasamos los argumentos a la pantalla PaymentPage
            final arguments = settings.arguments as Map<String, dynamic>?;
            builder = (BuildContext _) => PaymentPage(
                  arguments: arguments ?? {},
                );
            break;
          default:
            builder =
                (BuildContext _) => const ProfilePage(); // Ruta predeterminada
            break;
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
