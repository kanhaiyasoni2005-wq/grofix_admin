
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
  required String stock,

  required String catagory,
  required String name,
  required String price,
  required String Description,
  required String image,
}) async {
  await FirebaseFirestore.instance.collection("User").add({
    "name": name,
   
    "catagory": catagory,
     "Description": Description,
    "price": double.tryParse(price) ?? 0,
    "image": image,
    "createdAt": DateTime.now(),
    "stock": int.tryParse(stock) ?? 0,
  });
}
}