class SubscriptionModel {
  final int id;
  final String plan;
  final DateTime startDate;
  final DateTime endDate;
  final String stripeSubscriptionId;
  late final String status;
  final DateTime trialEndsAt;
  final int userId;

  SubscriptionModel({
    required this.id,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.stripeSubscriptionId,
    required this.status,
    required this.trialEndsAt,
    required this.userId,
  });

  // Convertir la clase a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan': plan,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'stripeSubscriptionId': stripeSubscriptionId,
      'status': status,
      'trialEndsAt': trialEndsAt.toIso8601String(),
      'userId': userId,
    };
  }

  // Crear una instancia desde JSON
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int,
      plan: json['plan'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      stripeSubscriptionId: json['stripeSubscriptionId'] as String,
      status: json['status'] as String,
      trialEndsAt: DateTime.parse(json['trialEndsAt']),
      userId: json['userId'] as int,
    );
  }

  // Método para crear una copia con cambios
  SubscriptionModel copyWith({
    int? id,
    String? plan,
    DateTime? startDate,
    DateTime? endDate,
    String? stripeSubscriptionId,
    String? status,
    DateTime? trialEndsAt,
    int? userId,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      status: status ?? this.status,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      userId: userId ?? this.userId,
    );
  }
}
