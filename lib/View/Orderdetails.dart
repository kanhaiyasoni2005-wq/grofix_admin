import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/model/model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  // 🔥 OPEN MAP
  void openMap(BuildContext context, double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng"
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Map open nahi ho paaya"))
      );
    }
  }

  // 🔥 NAVIGATION
  void startNavigation(BuildContext context, double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng"
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Navigation start nahi ho paaya"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [

            // 🧾 ORDER INFO
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Price: ₹${order.totalPrice}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 5),

                    Text("Payment: ${order.paymentMethod}"),
                    Text("Status: ${order.status}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📍 ADDRESS + MAP BUTTONS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Delivery Address",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    Text(order.address['name'] ?? ""),
                    Text(order.address['phone']?.toString() ?? ""),

                    const SizedBox(height: 5),

                    Text("${order.address}"),

                    const SizedBox(height: 12),

                    // 🔥 VIEW LOCATION
                    ElevatedButton.icon(
                      onPressed: () {
                        openMap(context, order.latitude, order.longitude);
                      },
                      icon: Icon(Icons.map),
                      label: Text("View Location"),
                    ),

                    const SizedBox(height: 8),

                    // 🔥 START NAVIGATION
                    ElevatedButton.icon(
                      onPressed: () {
                        startNavigation(context, order.latitude, order.longitude);
                      },
                      icon: Icon(Icons.navigation),
                      label: Text("Start Navigation"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🛒 PRODUCTS LIST
            const Text("Products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            ...order.products.map<Widget>((item) {
              return Card(
                child: ListTile(
                  leading: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(2),
          ),
          child: CachedNetworkImage(
            imageUrl: item['image'] ?? '',
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            placeholder: (context, url) => SizedBox(),
            errorWidget: (context, url, error) =>
                Icon(Icons.broken_image),
          ),
        ),
                  title: Text(item['name'] ?? ""),
                  subtitle: Text("Qty: ${item['quantity']}"),
                  trailing: Text("₹ ${item['price']}"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}