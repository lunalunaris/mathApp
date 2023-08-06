import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/User.dart';
import 'package:math/UI/account/recover_password.dart';
import 'package:math/UI/account/register.dart';
import 'package:math/UI/learning/level_choice.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52444),
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: const Scaffold(
        body: SizedBox(
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
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserForm();
}

User user = User();

class _UserForm extends State<UserForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  signIn() async {
    var email = emailController.text;
    var password = passwordController.text;
    //login the user, then:
    // const callerUid = context.auth.uid;  //uid of the user calling the Cloud Function
    // const callerUserRecord = await admin.auth().getUser(callerUid);
    // if (!callerUserRecord.customClaims.admin) {
    //   throw new NotAnAdminError('Only Admin users can create new users.');
    // set custom claims/roles for users who have already chosen the level
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LevelChoice(
                  user: user,
                )));

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
    user = User();
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
            const Text("Log in",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            const Text("Welcome back",
                style: TextStyle(fontSize: 20, color: Colors.teal)),
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
                        hintText: "password")),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  signIn();
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text("Register",
                        style: TextStyle(fontSize: 20, color: Colors.teal))),
                SizedBox(width: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecoverPasswd()));
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 20, color: Colors.teal),
                    ))
              ],
            )
          ],
        ));
  }
}