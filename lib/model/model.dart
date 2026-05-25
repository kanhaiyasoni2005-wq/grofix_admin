import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String userId;
  List products;
  double totalPrice;
  String paymentMethod;
  Map<String, dynamic> address;
  String status;
  DateTime createdAt;

  // 🔥 NEW LOCATION FIELDS
  double latitude;
  double longitude;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.address,
    required this.status,
    required this.createdAt,

    // 🔥 ADD HERE
    required this.latitude,
    required this.longitude,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String id) {
    final createdAtValue = data['createdAt'];
    DateTime createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is String) {
      createdAt = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    final productsData = data['products'];
    final products = productsData is List ? List.from(productsData) : [];

    final addressData = data['address'];
    final address = addressData is Map
        ? Map<String, dynamic>.from(
            addressData.map((key, value) =>
                MapEntry(key.toString(), value)))
        : <String, dynamic>{};

    return OrderModel(
      id: id,
      userId: data['userId'] ?? "",
      products: products,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? "cod",
      address: address,
      status: data['status'] ?? "pending",
      createdAt: createdAt,

      // 🔥 SAFE LOCATION PARSING
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }
}