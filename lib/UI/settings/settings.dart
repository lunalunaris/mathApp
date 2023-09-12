import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/account/login.dart';
import 'package:math/UI/admin/admin_init.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:math/UI/learning/level_choice.dart';

import '../../generated/l10n.dart';

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => _Settings();

  const UserSettings({Key? key}) : super(key: key);
}

class _Settings extends State<UserSettings> {
  late User? user;
  late String userRole = "";
  bool connected=true;
  late FirebaseFirestore db;

  @override
  void initState() {
    initConnect();
    if(connected) {
    db = FirebaseFirestore.instance;
    user = FirebaseAuth.instance.currentUser;
      initRole();
    }
    super.initState();
  }
  initConnect ()async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult==ConnectivityResult.none || connectivityResult==ConnectivityResult.bluetooth){
      connected=false;
    }
    setState(() {
    });
  }
  clearProgress(BuildContext context) {
    try {
      clearPractice();
      clearSection();
      clearTopic();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).progressCleared)));
    }
    catch (e){
      print(e.toString());
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorCleaningProgress)));
    }
  }

  initRole() async {
    await db
        .collection("UserRole")
        .doc(user?.uid)
        .get()
        .then((querySnapshot) async {
      userRole = querySnapshot["role"];
      setState(() {});
    });
  }

  Future<void> clearPractice() async {
    var collection = FirebaseFirestore.instance
        .collection('PracticeCompleted')
        .where("user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearSection() async {
    var collection = FirebaseFirestore.instance
        .collection('SectionQuizCompleted')
        .where("user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearTopic() async {
    var collection = FirebaseFirestore.instance
        .collection('TopicQuizCompleted')
        .where("user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  signOutUser() {
    _signOut();
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).settings),
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
              child: ListView(
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/logo.png")))),
                  const Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.change_circle_outlined),
                    title: TextButton(
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LevelChoice()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ))),
                        child:  Text(
                          S.of(context).changeLevel,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_rounded),
                    title: TextButton(
                        onPressed: () {
                          if(connected) {
                            clearProgress(context);

                          }//implement some kind of notification
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ))),
                        child:  Text(
                          S.of(context).clearProgress,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: connected==true ? Colors.black54: Colors.blueGrey),
                        )),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: TextButton(
                        onPressed: () {
                          if(connected) {
                            signOutUser();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ))),
                        child:  Text(
                          S.of(context).logOut,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: connected==true ? Colors.black54: Colors.blueGrey),
                        )),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  if (userRole == "admin")
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings_rounded),
                      title: TextButton(
                          onPressed: () {
                            if(connected) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminInit()));
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ))),
                          child:  Text(
                            S.of(context).adminPanel,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: connected==true ? Colors.black54: Colors.blueGrey),
                          )),
                    ),
                  const Divider(
                    height: 0,
                  ),
                ],
              ),
            ),
          )),

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          currentIndex: 1,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.book),
              label: S.of(context).learn,
            ),
            // BottomNavigationBarItem(
            //   icon: const Icon(Icons.games),
            //   label: S.of(context).game,
            // ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: S.of(context).setup,
            ),
          ],
          onTap: (option) {
            switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Learning()));
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