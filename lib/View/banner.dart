import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  final TextEditingController imageController = TextEditingController();
  bool isLoading = false;

  Future<void> addBanner() async {
    if (imageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter image URL")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance.collection("banners").add({
        "image": imageController.text.trim(),
        "createdAt": DateTime.now(),
      });

      imageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Banner Added Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Banner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 URL Input
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                hintText: "Enter Banner Image URL",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addBanner,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Banner"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}