import 'package:firebase/View/add%20_order.dart';
import 'package:firebase/View/banner.dart';
import 'package:firebase/View/deletebanner.dart';
import 'package:firebase/View/home_screnn.dart';
import 'package:firebase/View/staff_permission/DeliveryBoyManagementScreen.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [

            dashboardCard(
              context,
              "Add Product",
              Icons.add_box,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddOrder()),
                );
              
                // Product Add Screen
              },
            ),

            dashboardCard(
              context,
              "Update Product",
              Icons.edit,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Products()),
                );
                // Product Update Screen
              },
            ),

            dashboardCard(
              context,
              "Delivery Boys",
              Icons.delivery_dining,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeliveryBoyManagementScreen()),
                );
                // DeliveryBoyManagementScreen
              },
            ),

            dashboardCard(
              context,
              "Add Banner",
              Icons.image,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBannerScreen()),
                );
                // Banner Upload Screen
              },
            ),

            dashboardCard(
              context,
              "Delete Banner",
              Icons.delete,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BannerListScreen()),
                );
                // Banner Delete Screen
              },
            ),

            dashboardCard(
              context,
              "Orders",
              Icons.shopping_bag,
              () {
                // Orders Screen
              },
            ),

            dashboardCard(
              context,
              "Categories",
              Icons.category,
              () {
                // Category Screen
              },
            ),

            dashboardCard(
              context,
              "Users",
              Icons.people,
              () {
                // User Management
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}