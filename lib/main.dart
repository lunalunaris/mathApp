
import 'package:math/UI/account/login.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/User.dart';

late User user;
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,

        ),
        home: Login());
  }
}