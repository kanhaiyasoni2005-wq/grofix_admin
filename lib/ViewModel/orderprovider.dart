
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/model.dart';
import 'package:flutter/material.dart';

class Orderprovider extends ChangeNotifier{
List<OrderModel> orders = [];

void fetchAllOrders() {
  try {
    // ✅ ADMIN VIEW - FETCH ALL ORDERS (NO USER FILTER)
    print("🔍 Fetching ALL orders (Admin View)");

 
       FirebaseFirestore.instance
    .collection("orders")
    .where("accepted", isEqualTo: false)
    .orderBy("createdAt", descending: true) // ✅ Now orderBy works without where
        .snapshots()
        .listen((snapshot) {
      orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();

      notifyListeners();
      print("✅ All Orders fetched: ${orders.length}");
    }, onError: (error) {
      print("❌ Error fetching orders: $error");
    });
  } catch (e) {
    print("❌ Exception in fetchAllOrders: $e");
  }
}
Future<void> updateOrderStatus(String orderId, String status) async {
 await FirebaseFirestore.instance
    .collection("orders")
    .doc(orderId)
    .update({
  "status": status,

  if (status.toLowerCase().trim() == "delivered")
    "deliveredTime": FieldValue.serverTimestamp(),
});
}






Future<void> addProduct({
  String? productId,
  required String stock,
  required String catagory,
  required String name,
  required String price,
  required String Description,
  required String image,
}) async {

  // ID empty ho to generate karo
  if (productId == null ||
      productId.trim().isEmpty) {

    productId =
"${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}";
  }

  await FirebaseFirestore.instance
      .collection("User")
      .doc(productId) // ab empty nahi hogi
      .set({

    "productId": productId,
    "name": name,
    "catagory": catagory,
    "Description": Description,
    "price": double.tryParse(price) ?? 0,
    "image": image,
    "stock": int.tryParse(stock) ?? 0,
    "createdAt": FieldValue.serverTimestamp(),
  });
}
}