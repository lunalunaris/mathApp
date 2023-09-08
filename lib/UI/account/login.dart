import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/recover_password.dart';
import 'package:math/UI/account/register.dart';
import 'package:math/UI/learning/level_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../generated/l10n.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52444),
        title: Text(
          S.of(context).loginPage,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade500.withOpacity(0.8),
              Colors.teal.shade100.withOpacity(0.8),
            ],
          )),
          child: const UserForm(),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserForm();
}

class _UserForm extends State<UserForm> {
  User? user;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String level;
  late String lang;
  bool connected = false;

  signIn(BuildContext context) async {
    var email = emailController.text;
    var password = passwordController.text;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LevelChoice()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).accountWithThisEmailDoesNotExist)));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).incorrectPassword)));
        print('Wrong password provided for that user.');
      }
    }
  }

/*  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );*/

  @override
  void initState() {
    user = null;
    initConnect();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    // lang = Platform.localeName;
    // initLevel();
    super.initState();
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  initLevel() async {
    await db
        .collection("UserLevel")
        .doc(user?.uid)
        .get()
        .then((querySnapshot) async {
      level = querySnapshot["level"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Text(S.of(context).logIn,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Text(S.of(context).welcomeBack,
                style: const TextStyle(fontSize: 20, color: Colors.teal)),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Email",
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: S.of(context).password)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  if (connected) {
                    signIn(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(S.of(context).noInternetConnection)));
                  }
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                    backgroundColor: connected == true
                        ? MaterialStateProperty.all(Colors.teal)
                        : MaterialStateProperty.all(Colors.blueGrey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
                child: Text(
                  S.of(context).login,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      if (connected) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(S.of(context).noInternetConnection)));
                      }
                    },
                    child: Text(S.of(context).register,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.teal))),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                      onPressed: () {
                        if (connected) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RecoverPasswd()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(S.of(context).noInternetConnection)));
                        }
                      },
                      child: Text(
                        S.of(context).forgotPassword,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.teal),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
