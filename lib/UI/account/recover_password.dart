import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';

import '../../generated/l10n.dart';

class RecoverPasswd extends StatelessWidget {
  const RecoverPasswd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52444),
        title: Text(
          S.of(context).recoverPassword,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
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
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserForm();
}

class _UserForm extends State<UserForm> {
  final emailController = TextEditingController();
  bool connected = true;

  RecoverPasswdUser(BuildContext context) async {
    var email = emailController.text;
    //notifications if email is not used, etc
    var status;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .catchError((e) => status = e);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).invalidEmailAddress)));
      }
    }

    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
    // displayDialog(context, "Incorrect Input", "Invalid credentials");
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  void initState() {
    initConnect();
    setState(() {});
    super.initState();
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                height: 150,
              ),
              Text(S.of(context).getRecoveryEmail,
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold)),
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
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(25),
                child: ElevatedButton(
                    onPressed: () {
                      if (connected) {
                        RecoverPasswdUser(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(S.of(context).noInternetConnection)));
                      }
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                        backgroundColor: connected == true
                            ? MaterialStateProperty.all(Colors.teal)
                            : MaterialStateProperty.all(Colors.blueGrey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child: Text(
                      S.of(context).recoverPassword,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ));
  }
}
