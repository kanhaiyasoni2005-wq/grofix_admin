import 'package:firebase/View/add%20_order.dart';
import 'package:firebase/View/banner.dart';
import 'package:firebase/View/deletebanner.dart';
import 'package:firebase/View/drower/drower.dart';
import 'package:firebase/View/home_screnn.dart';
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

      AddOrder(),
      Products(),

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
              icon: Icon(Icons.add, color: Colors.black),
              label: "Add"),

              BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits_rounded, color: Colors.black),
              label: "products"),
        ],
      ),

      body: page[indexValue],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBannerScreen()),
              );
              // 🔥 LOG OUT FUNCTIONALITY
            },
            icon: Icon(Icons.image, color: Colors.black),
          ),
           Padding(
             padding: const EdgeInsets.all(9.0),
             child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BannerListScreen()),
                );
                // 🔥 LOG OUT FUNCTIONALITY
              },
              icon: Icon(Icons.delete, color: Colors.black),
                       ),
           )
        ],
      ),
    );
  }
}