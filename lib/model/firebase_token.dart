import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveAdminToken() async {
  String? token = await FirebaseMessaging.instance.getToken();

  if (token != null) {
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('settings')
        .set({
      'token': token,
    });

    print("Token Saved: $token");
  }
}