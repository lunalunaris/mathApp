import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;
//
// if (kIsWeb) {
// }
// }

import '../learning/learning.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyBJu7UoUsqnHchQPQnlNybmp4_G4vDTJQ0",
                appId: "1:1038366447891:web:33fb81222517178ad4e2e6",
                messagingSenderId: "1038366447891",
                projectId: "math-16d0d"))
        .whenComplete(() {
      print("completed");
      setState(() {});
    });
    Timer(
        const Duration(seconds: 3),
        () => FirebaseAuth.instance.currentUser == null
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Login()))
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Learning())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.pink.shade500.withOpacity(0.8),
                  Colors.teal.shade100.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30,bottom: 30),
                    margin: const EdgeInsets.all(30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Text("Welcome",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                            shadows: [
                              Shadow(
                                  color: Colors.white,
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 0.5)
                            ])),
                  )
                ]))));
  }
}
