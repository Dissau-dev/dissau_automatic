class UserModel {
  final int id;
  final String email;
  final String name;
  final String referralCode;
  final String? referredBy;
  final String stripeCustomerId;
  final String createdAt;
  final String updatedAt;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.referralCode,
    required this.referredBy,
    required this.stripeCustomerId,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  // Convertir de JSON a objeto
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      referralCode: json['referralCode'],
      referredBy: json['referredBy'],
      stripeCustomerId: json['stripeCustomerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      role: json['role'],
    );
  }

  // Convertir de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role,
    };
  }
}
