import 'package:flutter/material.dart';

class RadarEffect extends StatefulWidget {
  final bool isConnected;
  final bool isEditing;

  const RadarEffect(
      {Key? key, required this.isConnected, required this.isEditing})
      : super(key: key);

  @override
  _RadarEffectState createState() => _RadarEffectState();
}

class _RadarEffectState extends State<RadarEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation1;
  late Animation<double> _opacityAnimation1;
  late Animation<double> _sizeAnimation2;
  late Animation<double> _opacityAnimation2;

  @override
  void initState() {
    super.initState();

    // Configuración del controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duración de cada onda
    )..repeat(); // Repetir indefinidamente

    // Primera onda (más grande y más visible)
    _sizeAnimation1 = Tween<double>(begin: 12, end: 80).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation1 = Tween<double>(begin: 0.5, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Segunda onda (más pequeña y con menos opacidad)
    _sizeAnimation2 = Tween<double>(begin: 12, end: 50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation2 = Tween<double>(begin: 0.3, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60, // Espacio para las ondas
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Primera onda
          if (widget.isConnected)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: _sizeAnimation1.value,
                  height: _sizeAnimation1.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(widget.isEditing ? 0xff1D88E6 : 0xff2b2a29)
                        .withOpacity(
                      _opacityAnimation1.value,
                    ),
                  ),
                );
              },
            ),

          // Segunda onda
          if (widget.isConnected)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: _sizeAnimation2.value,
                  height: _sizeAnimation2.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(widget.isEditing ? 0xff1D88E6 : 0xff2b2a29)
                        .withOpacity(
                      _opacityAnimation2.value,
                    ),
                  ),
                );
              },
            ),

          // Burbuja central
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isConnected && widget.isEditing
                  ? const Color(0xff1D88E6)
                  : widget.isConnected
                      ? Color(0xff2b2a29)
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
