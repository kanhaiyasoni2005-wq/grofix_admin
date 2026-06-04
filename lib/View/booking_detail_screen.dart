import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const BookingDetailScreen({super.key, required this.data});

  // 🔥 GET LAT LNG (ROOT LEVEL SE)
  double getLat() {
    return double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0;
  }

  double getLng() {
    return double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0;
  }

  // 🔥 MAP OPEN
  void openMap(BuildContext context, double lat, double lng) async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Map open nahi ho paaya")),
      );
    }
  }

  // 🔥 NAVIGATION
  void startNavigation(BuildContext context, double lat, double lng) async {
    final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigation start nahi ho paaya")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = data['address'];

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),

      body: ListView(
        children: [

          // IMAGE
         Container(
  color: Colors.grey[200],
  // child: Image.network(
  //   data['image'] ?? '',
  //   height: 250,
  //   width: double.infinity,
  //   fit: BoxFit.contain,
  // ),
  child: Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => SizedBox(),
            errorWidget: (context, url, error) =>
                Icon(Icons.broken_image),
          ),
        ),
      ),
),

          const SizedBox(height: 10),

          // INFO CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Service: ${data['service'] ?? ''}"),
                  Text("Category: ${data['category'] ?? ''}"),
                  Text("Description: ${data['description'] ?? ''}"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ADDRESS CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: address == null
                  ? const Text("No Address")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),

                        Text(address['name'] ?? ""),
                        Text(address['phone']?.toString() ?? ""),
                        Text(address['Address'] ?? ""),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: () {
                            double lat = getLat();
                            double lng = getLng();

                            if (lat == 0.0 || lng == 0.0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Location available nahi hai")),
                              );
                              return;
                            }

                            openMap(context, lat, lng);
                          },
                          icon: const Icon(Icons.map),
                          label: const Text("View Location"),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                double lat = getLat();
                                double lng = getLng();
                            
                                if (lat == 0.0 || lng == 0.0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Location available nahi hai")),
                                  );
                                  return;
                                }
                            
                                startNavigation(context, lat, lng);
                              },
                              icon: const Icon(Icons.navigation),
                              label: const Text("Start Navigation"),
                            ),

                            SizedBox(width: 10),
                            if (data['category'] == "CSC Service")
  ElevatedButton(
    onPressed: () async {
      final pdfUrl = data['pdf']?.toString();

      if (pdfUrl == null || pdfUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF URL available nahi hai")),
        );
        return;
      }

      try {
        final uri = Uri.parse(
          pdfUrl.startsWith("http") ? pdfUrl : "https://$pdfUrl",
        );

        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("PDF ERROR: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF open nahi ho paaya")),
        );
      }
    },
    child: const Text("Open PDF"),
  ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}