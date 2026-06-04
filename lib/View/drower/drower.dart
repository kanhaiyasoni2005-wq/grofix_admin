import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/View/LoginPage/loginscreen.dart';
import 'package:firebase/View/admin_dashboard/Admindashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Drawer(
        child: Center(
          child: Text("User not found"),
        ),
      );
    }

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('staff')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Profile not found"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          final name = data['name'] ?? '';
          final email = data['email'] ?? '';
          final role = data['role'] ?? '';

          return Column(
            children: [

              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person, size: 40),
                ),
              ),

              

              // Sirf Admin ko dikhana
              if (role == 'admin')
                ListTile(
  leading: const Icon(Icons.dashboard),
  title: const Text("Admin Dashboard"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AdminDashboardScreen(),
      ),
    );
  },
),
              // Sirf Admin ko dikhana
              

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {

                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const Loginscreen(),
  ),
  (route) => false,
);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}