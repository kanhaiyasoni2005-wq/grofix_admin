import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/View/Orderdetails.dart';
import 'package:firebase/ViewModel/orderprovider.dart';
import 'package:firebase/model/firebase_token.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final List<String> statusList = [
    "pending",
    "order placed",
    "order confirmed",
    "dispatched",
    "out for delivery",
    "delivered",
    "this location is not serviceable",
    "order items",
    "return_accepted",
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<Orderprovider>(context, listen: false)
          .fetchAllOrders();
    });
getToken();
saveAdminToken();
 listenTokenRefresh(); 

  }
  Future<void> getToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();

    print("TOKEN: $token");

    if (token == null) {
      print("Token is null");
      return;
    }

    await FirebaseFirestore.instance
        .collection("admin")
        .doc("settings")
        .set({
      "token": token,
    });

    print("Token saved successfully");
  } catch (e) {
    print("Error getting/saving token: $e");
  }
}

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "order confirmed":
        return Colors.blue;
      case "dispatched":
        return Colors.purple;
      case "out for delivery":
        return Colors.teal;
      case "delivered":
        return Colors.green;
      case "failed":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),

      body: Consumer<Orderprovider>(
        builder: (context, vm, child) {

          if (vm.orders.isEmpty) {
            return const Center(child: Text("No Orders Found"));
          }

          return ListView.builder(
            itemCount: vm.orders.length,
            itemBuilder: (context, index) {

              var order = vm.orders[index];

              String currentStatus = (order.status ?? "").toLowerCase();

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailsScreen(order: order),
                    ),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      // 🔥 LEFT SIDE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "₹ ${order.totalPrice}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              currentStatus.toUpperCase(),
                              style: TextStyle(
                                color: getStatusColor(currentStatus),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔥 accept button
                     SizedBox(
  width: 100,
  child: ElevatedButton(
    onPressed: () async {

  String uid =
      FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection("orders")
      .doc(order.id)
      .update({
    "accepted": true,
    "acceptedBy": uid,
    "status": "order confirmed",
  });
},
    child: const Text("Accept"),
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