import 'package:dissau_automatic/src/pages/profile/subscription_page.dart';
import 'package:flutter/material.dart';

import '../../preferencias_usuarios/preferencias_usuario.dart';

class AccountPage extends StatelessWidget {
  _logOut(BuildContext context) async {
    final prefs = new PreferenciasUsuario();
    prefs.token = "";

    Navigator.pushReplacementNamed(context, 'login');
  }

  _onPlan(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubscriptionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 0.6,
            stops: [0.3, 1.0],
            colors: [
              Color(0xFF372781),
              Color(0xFF25253A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Espaciado superior
              const SizedBox(height: 30),
              // Contenedor principal
              Container(
                color: const Color.fromARGB(235, 11, 11, 28),
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chevron IconButton
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 10),
                    // Contenedor de lista y título
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título
                          const Text(
                            'Mi cuenta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          // Lista
                          Container(
                            height: 300, // Ajusta la altura según sea necesario
                            child: ListView(
                              children: [
                                _SettingsTile(
                                  title: 'Cuenta',
                                  subtitle: 'example@gmail.com',
                                  onTap: () {},
                                  trailing: TextButton(
                                      child: const Text(
                                        "Cerrar Sesión",
                                        style: TextStyle(
                                            color: Color(0xffE90C91),
                                            fontFamily: 'Poppins'),
                                      ),
                                      onPressed: () => _logOut(context)),
                                ),
                                _SettingsTile(
                                  title: '3 Months + free week',
                                  subtitle: 'venc 11/12/2024',
                                  trailing: const TextButton(
                                    onPressed: null,
                                    child: Text(
                                      "Ampliar",
                                      style: TextStyle(
                                          color: Color(0xff30bff7),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  onTap: () => _onPlan(context),
                                ),
                                _SettingsTile(
                                  title: 'Cambiar Contraseña',
                                  subtitle: '',
                                  onTap: () {},
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget trailing;
  const _SettingsTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      required this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      child: Column(
        children: [
          const Divider(color: Colors.white24),
          ListTile(
              onTap: onTap,
              contentPadding: const EdgeInsets.symmetric(vertical: -4.0),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w100,
                ),
              ),
              trailing: trailing),
        ],
      ),
    );
  }
}