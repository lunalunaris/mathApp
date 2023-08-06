import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:math/UI/learning/level_choice.dart';



class UserSettings extends StatefulWidget {
  late User? user;

  @override
  _Settings createState() => _Settings();

  UserSettings({Key? key, required this.user}) : super(key: key);
}

class _Settings extends State<UserSettings> {
  late User? user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  clearProgress() {
    //delete stuff associated with user in fb
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 100),
              Table(
                  children: [
                    TableRow(children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LevelChoice(user: user)));
                          },
                          child: Text("Change class"))
                    ]),
                    TableRow(children: [
                      ElevatedButton(onPressed: () {
                        clearProgress();
                      }, child: Text("Clear progress")),
                    ]),
                    TableRow(children: [
                      ElevatedButton(
                          onPressed: () {
                            //logout the user
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                Login()));
                          },
                          child: Text("Log out"))
                    ])

                  ])

            ])),
    bottomNavigationBar: BottomNavigationBar(
    backgroundColor: Colors.teal,
    items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
    icon: Icon(Icons.book),
    label: "Learn",
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.games),
    label: "Game",
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: "Setup",
    ),
    ],
    onTap: (option) {
    switch (option) {
    case 0:
    Navigator.of(context).pop();
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Learning(user: user)));
    break;
    }
    // case 2:
    //   Navigator.of(context).pop();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               Game(user: user)));
    //   break;
    //   case 3:
    //     Navigator.of(context).pop();
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => Settings(user: user)));
    //     break;
    // }
    },
    selectedItemColor: Colors.pink),
    );
  }
}
