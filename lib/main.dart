import 'dart:async';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/bloc/provider.dart';
import 'src/pages/main/home_page.dart';
import 'src/routes/routes.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = PreferenciasUsuario();
  await prefs;

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  Stripe.publishableKey =
      'pk_test_51P4caFDrtegwEnl3baIqBDl1Id2beUGIBBUQOK2UfhThO0buETVWO3RDt5WZgc00Vk4qQa7HgFIENycYkCWuw4Jq00sw8wPXAX';
  await initializeService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final user = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins', // Usar la fuente declarada
        ),
        initialRoute: user.token.isEmpty ? "login" : "home",
        routes: getRutas(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => const HomePage());
        },
      ),
    );
  }
}
