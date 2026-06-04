import 'dart:async';

import 'package:firebase/View/BottomNavigation.dart';
import 'package:firebase/View/LoginPage/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreen();
}

class _splashScreen extends State<splashScreen> {

  bool isOffline = false;
  StreamSubscription? connectivitySub;

  @override
  void initState() {
    super.initState();

    // 🔥 real-time internet listener (SAFE)
    connectivitySub =
        Connectivity().onConnectivityChanged.listen((result) {

      bool noInternet = result == ConnectivityResult.none;

      if (!mounted) return;

      setState(() {
        isOffline = noInternet;
      });

      if (!noInternet) {
        checkLogin();
      }
    });

    checkInternetAndProceed();
  }

  @override
  void dispose() {
    connectivitySub?.cancel(); // 🔥 memory leak fix
    super.dispose();
  }

  // 🔹 First time check
  void checkInternetAndProceed() async {
    var result = await Connectivity().checkConnectivity();

    if (!mounted) return;

    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
    } else {
      checkLogin();
    }
  }

  // 🔹 Login check
  void checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // 🔥 simulate loading

    if (!mounted) return;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    }
  }

  // 🔹 Retry button
  void retry() {
    checkInternetAndProceed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 🔥 premium look
      body: Center(
        child: isOffline
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    "No Internet ❌",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: retry,
                    child: Text("Retry"),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // 🔥 STYLISH grofix TEXT
                  Text(
                    "GROFIX",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.yellow,
                            Colors.orange,
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}


