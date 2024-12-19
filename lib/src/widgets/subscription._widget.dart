import 'dart:convert';
import 'package:dissau_automatic/providers/subscription_model.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SubscriptionWidget extends StatefulWidget {
  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

final usuario = PreferenciasUsuario().user;
final _pref = new PreferenciasUsuario();

class _SubscriptionWidgetState extends State<SubscriptionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshSubscription() async {
    setState(() {
      _isLoading = true;
    });
    _controller.repeat(); // Inicia la animación

    try {
      final response = await http.get(
        Uri.parse(
            'https://jumb2bot-backend.onrender.com/subscription/byUser/${usuario?.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['subscription'] != null) {
          final updatedSubscription =
              SubscriptionModel.fromJson(data['subscription']);

          // Actualiza la suscripción localmente (ejemplo con SharedPreferences)
          await _pref.updateSubscriptionInStorage(updatedSubscription);

          Fluttertoast.showToast(
            msg: 'Subscription updated successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );
        }
      } else {
        final error = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: error['message'] ?? 'Failed to refresh subscription',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _controller.stop(); // Detiene la animación
      _controller.reset(); // Reinicia el ícono
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.1416,
            child: IconButton(
              onPressed: _isLoading ? null : _refreshSubscription,
              icon: const Icon(Icons.refresh_rounded,
                  color: const Color(0xFF1D88E6)),
              color: const Color(0xFF1D88E6),
            ),
          );
        },
      ),
    );
  }
}
