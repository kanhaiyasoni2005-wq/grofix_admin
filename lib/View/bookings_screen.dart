import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/View/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookingsScreen extends StatelessWidget {
  AdminBookingsScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Bookings")),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
    .collection('bookings')
    .orderBy('createdAt', descending: true)
    .snapshots(),

        builder: (context, snapshot) {

          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          }

          // 📭 No Data
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No Data Found"));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("No Bookings Available"));
          }

          // 📋 List
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final data = docs[index].data() as Map<String, dynamic>;

              // 📅 Date format
              String date = "No Date";
              if (data['createdAt'] != null) {
                DateTime dt = data['createdAt'].toDate();
                date = "${dt.day}/${dt.month}/${dt.year}";
              }

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
        
                  // 🖼 IMAGE
                  leading: data['image'] != null &&
                          data['image'].toString().isNotEmpty
                      ? ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? '',
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            placeholder: (context, url) => SizedBox(),
            errorWidget: (context, url, error) =>
                Icon(Icons.broken_image),
          ),
        )
                      : Icon(Icons.image),

                  // 🛠 SERVICE NAME
                  title: Text(
                    data['service'] ?? 'No Service',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // 📄 DETAILS
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['category'] ?? ''),
                      SizedBox(height: 4),
                      Text(date),
                    ],
                  ),

                  trailing: Icon(Icons.arrow_forward_ios, size: 16),

                  // 👉 OPEN DETAIL SCREEN
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailScreen(data: data, ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}