import 'package:dissau_automatic/providers/subscription_model.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PaymentPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

final subscription = PreferenciasUsuario().subscription;
final _pref = new PreferenciasUsuario();
final usuario = PreferenciasUsuario().user;

class _PaymentPageState extends State<PaymentPage> {
  String? _clientSecret;
  bool isLoading = false;

  // Método para crear la suscripción
  Future<void> createSubscription(int userId, String priceId) async {
    setState(() {
      isLoading = true;
    });

    final url =
        Uri.parse('https://jumb2bot-backend.onrender.com/subscription/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'priceId': priceId}),
    );

    print("priceId: ${widget.arguments['price_id']}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Validar si 'createdSub' existe y no es null
      if (data['createdSub'] != null) {
        // Convertir el JSON a un objeto SubscriptionModel
        final subscriptionModel = data['createdSub'];

        // Guardar suscripción
        await _pref.saveSubscription(subscriptionModel);

        setState(() {
          _clientSecret = data['clientSecret'];
          isLoading = false;
        });

        print('Client Secret obtenido: $_clientSecret');
        print('Subs obtenida: ${data['createdSub']}');

        // Mostrar mensaje si la suscripción está incompleta
        if (data['message'] != null) {
          Fluttertoast.showToast(
            msg: data['message'], // Mensaje del servidor
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.amber,
            textColor: Colors.black,
            fontSize: 16.0,
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Error: La suscripción no fue creada correctamente.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });

      print('Error al crear suscripción: ${response.body}');
      Fluttertoast.showToast(
        msg: "Error: ${response.body}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 230, 39, 29),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> showPaymentSheet(
      BuildContext context, String clientSecret) async {
    if (clientSecret.isEmpty) {
      print('Error: Client Secret no está disponible.');
      return;
    }

    try {
      // Inicializar el PaymentSheet con parámetros personalizados
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Dissau Jumb2Bot',
          allowsDelayedPaymentMethods:
              false, // Solo métodos inmediatos (tarjeta)
          style: ThemeMode.dark, // Modo oscuro

          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
                background: const Color(0xFF31314B), // Fondo principal
                primary: Color(0xFF1D88E6), // Color principal
                componentBackground: Color(0xFF212D63), // Componentes
                icon: Colors.white, // Iconos
                primaryText: Colors.white, // Texto principal
                secondaryText: Color(0xFFABB2BF), // Texto secundario
                placeholderText: Color(0xFFABB2BF),
                componentText: Colors.white,
                componentDivider: Color(0xFF1D88E6),
                componentBorder: Color(0xFF1D88E6) // Placeholder
                ),
            shapes: PaymentSheetShape(
              borderRadius: 8.0, // Bordes redondeados para los inputs
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF1D88E6),
                  text: Color(0xFF1A1B25),
                  // Botón principal
                ), // Texto del botón
              ),
              shapes: PaymentSheetPrimaryButtonShape(
                borderWidth: 2,
              ),
            ),
          ),
        ),
      );

      // Mostrar el PaymentSheet
      await Stripe.instance.presentPaymentSheet();
      subscription?.status = 'active';
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago confirmado con éxito')),
      );
    } catch (e) {
      // Manejar errores
      if (e is StripeException) {
        print('Error Stripe: ${e.error.localizedMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.error.localizedMessage}')),
        );
      } else {
        print('Error al mostrar PaymentSheet: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al mostrar PaymentSheet')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = widget.arguments;
    final productName = arguments['product_name'] ?? 'Plan';
    final price = arguments['price'];
    final price_id = arguments['price_id'];

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left_sharp,
                        size: 30, color: Colors.white),
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                    child: Icon(
                  Icons.payment_rounded,
                  color: Colors.white,
                  size: 90,
                )),
                const SizedBox(height: 40),
                Text(
                  productName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Disfruta de todos los beneficios premium ${usuario?.id} por solo $price',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54, width: 1),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalles:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- Acceso ilimitado a funciones premium.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '- Soporte prioritario 24/7.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '- Actualizaciones exclusivas.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (_clientSecret == null)
                  _buildButton(
                    label: isLoading ? 'Loading...' : 'Crear suscripción',
                    onPressed: isLoading
                        ? null
                        : () => createSubscription(usuario!.id, price_id),
                  ),
                const SizedBox(height: 20),
                if (_clientSecret != null)
                  _buildButton(
                    label: 'Confirmar Pago',
                    onPressed: () => showPaymentSheet(context, _clientSecret!),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String label, required VoidCallback? onPressed}) {
    return Container(
      width: 320.0,
      height: 52.0,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF372781),
            blurRadius: 20.0,
            offset: Offset(0.0, 8.0),
          )
        ],
        borderRadius: BorderRadius.circular(50.0),
        color: Color(0xFF1D88E6),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
