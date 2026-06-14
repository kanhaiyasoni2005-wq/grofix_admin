import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/View/Orderdetails.dart';
import 'package:firebase/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AcceptedOrdersScreen extends StatelessWidget {
  AcceptedOrdersScreen({super.key});

  final List<String> statusList = [
    "order confirmed",
    "dispatched",
    "out for delivery",
    "delivered",
    "this location is not serviceable",
    "order items",
    "return_accepted",
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "order confirmed":
        return Colors.blue;
      case "dispatched":
        return Colors.purple;
      case "out for delivery":
        return Colors.orange;
      case "delivered":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Accepted Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("acceptedBy", isEqualTo: uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No Accepted Orders",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

  final doc = docs[index];

  final order = OrderModel.fromMap(
    doc.data() as Map<String, dynamic>,
    doc.id,
  );

  String currentStatus =
      (order.status )
          .toLowerCase();

  return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Order ID",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      Text(
                        order.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "₹ ${order.totalPrice}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        currentStatus.toUpperCase(),
                        style: TextStyle(
                          color:
                              getStatusColor(currentStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        initialValue: statusList.contains(
                                currentStatus)
                            ? currentStatus
                            : "order confirmed",

                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),

                        items: statusList.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status.toUpperCase(),
                            ),
                          );
                        }).toList(),
                



                        onChanged: (value) async {
                          if (value == null) return;

                          await FirebaseFirestore
                              .instance
                              .collection("orders")
                              .doc(order.id)
                              .update({
                            "status": value,

                            if (value ==
                                "delivered")
                              "deliveredTime":
                                  FieldValue
                                      .serverTimestamp(),
                          });

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "Status Updated",
                              ),
                            ),
                          );
                        },
                      ),
   const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.visibility),
    label: const Text("View Order Details"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderDetailsScreen(order: order),
        ),
      );
    },
  ),
),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}