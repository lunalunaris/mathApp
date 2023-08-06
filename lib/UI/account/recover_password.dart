import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/User.dart';
import 'package:math/UI/account/login.dart';
import 'package:math/UI/learning/level_choice.dart';

class RecoverPasswd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52444),
        title: const Text(
          "Recover Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: UserForm(),
          ),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserForm createState() => _UserForm();
}


class _UserForm extends State<UserForm> {
  final emailController = TextEditingController();

  RecoverPasswdUser() async {
    var email = emailController.text;
    //notifications if email is not used, etc
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login()));
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
    child: Column(
      children: [
        const SizedBox(
          height: 150,
        ),
        const Text("Get recovery email",
            style: TextStyle(fontSize: 30, color: Colors.pink,fontWeight: FontWeight.bold)),
        SizedBox(height: 30,),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: "Email",
                )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        ElevatedButton(
            onPressed: () {
              RecoverPasswdUser();
            },
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.teal),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
            child: const Text(
              "Recover Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
      ],
    ));
  }
}
