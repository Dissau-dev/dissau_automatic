import 'package:flutter/material.dart';

import '../../widgets/app_bart.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: CustomAppBar(), body: SafeArea(child: _placeholder())),
    );
  }

  Widget _placeholder() {
    return Stack(
      children: [
        // Imagen de fondo
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF372781), // Color principal (centro)
                Color(0xFF25253A), // Color de fondo (extremos)
              ],
              radius: 0.6, // Ajusta el radio para el efecto deseado
              center: Alignment(0.0, 0.7), // Centrado un poco hacia arriba
              stops: [0.3, 1.0], // Controla la transición entre colores
            ),
          ),
        ),
      ],
    );
  }
}
