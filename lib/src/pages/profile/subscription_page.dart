import 'package:dissau_automatic/src/pages/profile/account_page.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IconButton
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                  padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                ),
              ),
              const SizedBox(height: 40), // Separación
              // Imagen centrada
              Center(
                child: Image.asset(
                  'assets/images/Bedge.png', // Asegúrate de reemplazar con tu ruta de imagen
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),
              // Textos principales centrados
              const Text(
                'Título Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Texto secundario',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(), // Empuja los botones hacia la parte inferior
              // Botones con diseño
              Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E2D4D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4, // Sombra

                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () {
                        // Acción del botón
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Título Botón ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Texto secundario',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    '\$99.99',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
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
