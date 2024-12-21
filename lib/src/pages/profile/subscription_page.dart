import 'dart:ffi';

import 'package:dissau_automatic/providers/subscription_model.dart';
import 'package:dissau_automatic/src/pages/profile/payment_page.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:dissau_automatic/src/widgets/subscription._widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../providers/user_provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final _pref = new PreferenciasUsuario();
  final subscription = PreferenciasUsuario().subscription;
  final usuario = PreferenciasUsuario().user;
  final UserProvider _userProvider = UserProvider();
  bool cancelling = false; // Variable para manejar el estado de cancelación

  void cancelSubscription(BuildContext context, int userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Cancel Subscription'),
            content: const Text(
              'Are you sure you want to cancel your active subscription?',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() => cancelling = true);

                  // Llamada al método de cancelación
                  final response =
                      await _userProvider.cancelUserSubscription(userId);

                  setState(() => cancelling = false);
                  Navigator.pop(context); // Cierra el diálogo

                  if (response['ok']) {
                    Fluttertoast.showToast(
                      msg: response['message'],
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    if (response['subscription'] != null) {
                      try {
                        final newSubscription = SubscriptionModel.fromJson(
                            response['subscription']);
                        await _pref
                            .updateSubscriptionInStorage(newSubscription);
                      } catch (error) {
                        print(error);
                        print("fail subs update");
                      }
                    }
                  } else {
                    _showErrorDialog(context, response['message']);
                  }
                },
                child: cancelling
                    ? const CircularProgressIndicator() // Mostrar carga
                    : const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchPlans() async {
    final url = Uri.parse('https://jumb2bot-backend.onrender.com/plans/all');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((plan) => {
                  'product_name': plan['product_name'],
                  'product_id': plan['product_id'],
                  'price_id': plan['price_id'],
                  'price': plan['price'],
                  'description': plan['description'],
                })
            .toList();
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch plans: $e');
    }
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
              Color(0xFF372781), // Color principal
              Color(0xFF25253A), // Color de fondo
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Subscription Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (subscription?.plan == null)
                  Image.asset(
                    'assets/images/Bedge.png',
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width * 2.0,
                  ),
                if (subscription?.plan != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF31314B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Spacer(), SubscriptionWidget()],
                        ),
                        Text(
                          'Plan: ${subscription?.plan}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Status: ${subscription?.status}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Expires on: ${subscription != null && subscription?.endDate != null ? DateFormat('dd/MM/yyyy').format(subscription!.endDate) : 'Unknown'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  cancelling ? Colors.grey : Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: cancelling
                                ? null // Deshabilitar si estamos en proceso de cancelación
                                : () {
                                    cancelSubscription(context, usuario!.id);
                                  },
                            child: const Text(
                              'Cancel suscription',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                const Text(
                  'Upgrade or Renew Your Plan',
                  style: TextStyle(
                    color: Color.fromARGB(255, 197, 197, 221),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchPlans(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load plans: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final plans = snapshot.data!;
                        return ListView.builder(
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF31314B),
                                  side: const BorderSide(
                                      color: Colors.white, width: 0.15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/profile/payment',
                                    arguments: plan,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan['product_name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          plan['description'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 197, 197, 221),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          plan['price'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No plans available'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
