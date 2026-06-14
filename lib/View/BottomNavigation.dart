import 'package:firebase/View/accept_order/acceptd_order.dart';
import 'package:firebase/View/banner.dart';
import 'package:firebase/View/deletebanner.dart';
import 'package:firebase/View/drower/drower.dart';
import 'package:firebase/View/orders.dart';

import 'package:firebase/View/bookings_screen.dart';
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
 

  late List<Widget> page;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    page = [
      Homepage(),
      // Products

      // 🔥 PASS USER ID HERE
      AdminBookingsScreen(),

      AcceptedOrdersScreen(),
      

    ];
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
}