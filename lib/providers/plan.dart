import 'dart:convert';
import 'package:http/http.dart' as http;

class Plan {
  final String productName;
  final String productId;
  final String priceId;
  final String price;
  final String description;

  Plan({
    required this.productName,
    required this.productId,
    required this.priceId,
    required this.price,
    required this.description,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      productName: json['product_name'],
      productId: json['product_id'],
      priceId: json['price_id'],
      price: json['price'],
      description: json['description'],
    );
  }
}

Future<List<Plan>> fetchPlans() async {
  final response = await http
      .get(Uri.parse('https://jumb2bot-backend.onrender.com/plans/all'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Plan> plans = body.map((dynamic item) => Plan.fromJson(item)).toList();
    return plans;
  } else {
    throw Exception('Failed to load plans');
  }
}
