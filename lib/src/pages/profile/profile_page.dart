import 'package:dissau_automatic/src/pages/profile/account_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 0.6,
            stops: [0.3, 1.0], // Controla la transición entre colores
            colors: [
              Color(0xFF372781), // Color principal (centro)
              Color(0xFF25253A), // Color de fondo (extremos)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Espacio superior
              const SizedBox(height: 30),
              Container(
                color: Color.fromARGB(
                    235, 11, 11, 28), // Color de fondo (extremos),
                padding: EdgeInsets.only(top: 20, left: 50, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuración',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // ListView dentro de un contenedor con altura fija
                    Container(
                      height: 300, // Ajusta la altura según sea necesario
                      child: ListView(
                        children: [
                          _SettingsTile(
                            title: 'Configuración de la aplicación',
                            subtitle: 'Idioma, Modo Oscuro, etc',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            title: 'Mi Cuenta',
                            subtitle: 'Contraseña, suscripción, etc',
                            onTap: () {
                              Navigator.pushNamed(context, '/profile/account');
                            },
                          ),
                          _SettingsTile(
                            title: 'Recomendar a un amigo',
                            subtitle: 'Invita a amigos y recibe meses gratis',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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

  const _SettingsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 88,
        child: Column(
          children: [
            const Divider(color: Colors.white24),
            ListTile(
              onTap: onTap,
              contentPadding: EdgeInsets.symmetric(
                  vertical: -4.0), // Ajusta el valor vertical
              title: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w100),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ));
  }
}
