import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/pages/sms_page.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:dissau_automatic/src/routes/routes.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Asegúrate de inicializar el binding
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

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
        // ignore: unnecessary_null_comparison
        initialRoute: user.token.isEmpty ? "login" : "sms",
        routes: getRutas(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => SmsPage());
        },
      ),
    );
  }
}
