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
    Firebase.initializeApp( options:  const FirebaseOptions(
        apiKey: "AIzaSyBJu7UoUsqnHchQPQnlNybmp4_G4vDTJQ0",
        appId: "1:1038366447891:web:33fb81222517178ad4e2e6",
        messagingSenderId: "1038366447891",
        projectId: "math-16d0d")).whenComplete(() {
      print("completed");
      setState(() {});
    });    Timer(const Duration(seconds: 3),
            () => FirebaseAuth.instance.currentUser == null? Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const Login())) : Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Learning(user:FirebaseAuth.instance.currentUser ))
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text("Welcome", style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink)
              )
            ]
            )));
  }
}


