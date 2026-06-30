import 'package:firebase/View/LoginPage/loginscreen.dart';
import 'package:firebase/View/accept_order/acceptd_order.dart';
import 'package:firebase/View/drower/drower.dart';
import 'package:firebase/View/orders.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/View/bookings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() {
    return BottomState();
  }
}

class BottomState extends State<Bottomnavigation> {

  // ✅ CURRENT USER ID
 StreamSubscription<DocumentSnapshot>? blockSub;

  late List<Widget> page;

  @override
 @override
void initState() {
  super.initState();

  requestNotificationPermission();

  page = [
    Homepage(),
    AdminBookingsScreen(),
    AcceptedOrdersScreen(),
  ];


  listenBlockedStatus();
}
  Future<void> requestNotificationPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Permission: ${settings.authorizationStatus}');
}

  int indexValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
drawer: const AdminDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexValue,
        iconSize: 25,
        onTap: (int index) {
          setState(() {
            indexValue = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.list, color: Colors.black),
              label: "Bookings"),

          BottomNavigationBarItem(
              icon: Icon(Icons.post_add_rounded, color: Colors.black),
              label: "orders"),

              
        ],
      ),

      body: page[indexValue],
      appBar: AppBar(
        
      ),
    );
  }
 void listenBlockedStatus() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  blockSub = FirebaseFirestore.instance
      .collection("staff")
      .doc(user.uid)
      .snapshots()
      .listen((doc) async {

    if (!doc.exists) return;

    final data =
        doc.data() as Map<String, dynamic>?;

    String status =
        data?["status"] ?? "";

    if (status == "blocked" && mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Your account has been blocked",
          ),
        ),
      );

      await Future.delayed(
        const Duration(seconds: 1),
      );

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const Loginscreen(),
        ),
        (_) => false,
      );
    }
  });
}
}