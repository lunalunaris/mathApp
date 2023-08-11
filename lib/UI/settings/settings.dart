import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';
import 'package:math/UI/admin/adminInit.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:math/UI/learning/level_choice.dart';
import 'dart:developer' as developer;

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => _Settings();

  UserSettings({Key? key}) : super(key: key);
}

class _Settings extends State<UserSettings> {
  late User? user;
  late String userRole="";
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    initRole();
    super.initState();
  }

  clearProgress() {
    clearPractice();
    clearSection();
    clearTopic();
  }

  initRole() async {
    await db
        .collection("UserRole")
        .doc(user?.uid)
        .get()
        .then((querySnapshot) async {
      print("role completed");
      userRole = querySnapshot["role"];
      print(userRole);
      setState(() {});
    });
  }


  Future<void> clearPractice() async {
    var collection = FirebaseFirestore.instance.collection('PracticeCompleted').where(
        "user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
  Future<void> clearSection() async {
    var collection = FirebaseFirestore.instance.collection('SectionQuizCompleted').where(
        "user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
  Future<void> clearTopic() async {
    var collection = FirebaseFirestore.instance.collection('TopicQuizCompleted').where(
        "user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  signOutUser(){
    _signOut();
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Login()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade500.withOpacity(0.8),
              Colors.teal.shade100.withOpacity(0.8),
            ],
          )),
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 200),
              child: ListView(
                children: [
                  Divider(height: 0,),

                  ListTile(
                    leading: const Icon(Icons.change_circle_outlined),
                    title: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LevelChoice()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ))),
                        child: const Text(
                          "Change level",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  Divider(height: 0,),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_rounded),
                    title: TextButton(
                        onPressed: () {
                          clearProgress(); //implement some kind of notification
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ))),
                        child: const Text(
                          "Clear progress",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  Divider(height: 0,),

                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: TextButton(
                        onPressed: () {
                          signOutUser();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ))),
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  Divider(height: 0,),
                  if(userRole=="admin")
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_rounded),
                    title: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>  AdminInit()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ))),
                        child: const Text(
                          "Admin panel",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  Divider(height: 0,),
                ],
              ),
            ),

          )),
      //   Table(
      //       children: [
      //         TableRow(children: [
      //           ElevatedButton(
      //               onPressed: () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) =>
      //                             LevelChoice(user: user)));
      //               },
      //               child: Text("Change class"))
      //         ]),
      //         TableRow(children: [
      //           ElevatedButton(onPressed: () {
      //             clearProgress();
      //           }, child: Text("Clear progress")),
      //         ]),
      //         TableRow(children: [
      //           ElevatedButton(
      //               onPressed: () {
      //                 //logout the user
      //                 Navigator.push(
      //                     context, MaterialPageRoute(builder: (context) =>
      //                     Login()));
      //               },
      //               child: Text("Log out"))
      //         ])
      //
      //       ])
      //
      // ])),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          currentIndex: 2,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Learning()));
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
