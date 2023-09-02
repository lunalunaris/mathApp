import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';

import '../../generated/l10n.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52444),
        title:  Text(
          S.of(context).registerPage,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Scaffold(
        body:
            Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pink.shade500.withOpacity(0.8),
                    Colors.teal.shade100.withOpacity(0.8),
                  ],
                )),
            child: const UserForm(),),

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
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  Color emailColor= Colors.pinkAccent;
  registerUser() async {
    var email = emailController.text;
    var password = passwordController.text;
    var passwordRepeat = passwordRepeatController.text;
    if (email==""){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).emailFieldCannotBeEmpty)));
    }
    if(password =="" || passwordRepeat==""){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).passewordFieldCannotBeEmpty)));
    }
    //Register the user
    //notifications if email is already used, etc
    if (password == passwordRepeat) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(S.of(context).thePasswordIsTooWeak)));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).anAccountAlreadyExistsForThatEmail)));
        }
        else if(e.code == 'invalid-email'){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).theEmailIsInvalid)));
        }
      } catch (e) {
        print(e);
      }
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).passwordsDontMatch)));
    }

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
                height: 60,
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
                  child: TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        errorText: S.of(context).emailFieldCannotBeEmpty,
                        errorBorder:  const OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.red, width: 0.0),
                        ),
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
                  child: SingleChildScrollView(
                    child: TextFormField(
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        decoration: InputDecoration(
                            errorText: S.of(context).passwordFieldCannotBeEmpty,
                            errorBorder:  const OutlineInputBorder(
                              borderSide:  BorderSide(color: Colors.red, width: 0.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            hintText: S.of(context).password)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(0.8),
                  child: TextFormField(
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordRepeatController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterSomeText;
                        } else if (value != passwordController.text) {
                          return S.of(context).passwordsDontMatch;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorText: S.of(context).passwordFieldCannotBeEmpty,
                          errorBorder:  const OutlineInputBorder(
                            borderSide:  BorderSide(color: Colors.red, width: 0.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: S.of(context).password)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () {
                      registerUser();
                    },
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child:  Text(
                      S.of(context).register,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ));
  }
}
