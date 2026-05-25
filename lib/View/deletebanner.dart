import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerListScreen extends StatelessWidget {
  const BannerListScreen({super.key});

  Future<void> deleteBanner(String docId) async {
    await FirebaseFirestore.instance
        .collection("banners")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Banners"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("banners")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No banners found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index];
              String imageUrl = data["image"];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: const Text("Banner Image"),
                  
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // 🔥 Confirmation Dialog
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Banner"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await deleteBanner(data.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Banner Deleted")),
                        );
                      }
                    },
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