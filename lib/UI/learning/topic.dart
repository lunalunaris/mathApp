import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:math/UI/learning/practice.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/UI/learning/theory.dart';

import '../../Model/TopicModel.dart';
import '../../generated/l10n.dart';
import '../settings/settings.dart';

class Topic extends StatefulWidget {
  late TopicModel topic;
  late SectionModel section;

  @override
  State<Topic> createState() => _Topic();

  Topic({Key? key, required this.topic, required this.section})
      : super(key: key);
}

class _Topic extends State<Topic> {
  late User? user;
  late TopicModel topic;
  late SectionModel section;
  bool connected = true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userRole = "";

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    topic = widget.topic;
    section = widget.section;
    initConnect();
    if (connected){
    initRole();}
    print(userRole);
    super.initState();
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
  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }
  Future<void> clearPractice() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('Practice')
          .where("topicId", isEqualTo: topic.id);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete().then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(S.of(context).practiceTasksDeleted)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).deleteFailed)));
    }
  }

  Future<void> clearQuiz() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('Quiz')
          .where("topicId", isEqualTo: topic.id);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete().then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(S.of(context).quizzesDeleted)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).deleteFailed)));
    }
  }

  Future<void> clearTheory() async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('Theory')
          .where("topicId", isEqualTo: topic.id);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete().then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(S.of(context).theoryDeleted)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).deleteFailed)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(S.of(context).learning),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Theory(
                                          topic: topic,
                                          section: section,
                                        )));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: 290,
                            height: 150,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/theory.png"))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.purple.shade900.withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Text(
                                    S.of(context).theory,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                if (userRole == "admin")
                                  IconButton(
                                    onPressed: () {
                                      if (connected) {
                                        clearTheory();
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.deepPurple,
                                      size: 40,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Practice(
                                              topic: topic,
                                              section: section,
                                            )));
                                ;
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  width: 290,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              AssetImage("assets/temp2.png"))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade900
                                              .withOpacity(0.7),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Text(
                                          S.of(context).practice,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      if (userRole == "admin")
                                        IconButton(
                                          onPressed: () {
                                            if (connected) {
                                              clearPractice();
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.deepPurple,
                                            size: 40,
                                          ),
                                        )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Quiz(
                                              topic: topic,
                                              section: section,
                                            )));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  width: 290,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.7,
                                          image:
                                              AssetImage("assets/temp3.png"))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade900
                                              .withOpacity(0.7),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: const Text(
                                          "Quiz",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      if (userRole == "admin")
                                        IconButton(
                                          onPressed: () {
                                            if (connected) {
                                              clearQuiz();
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.deepPurple,
                                            size: 40,
                                          ),
                                        )
                                    ],
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: S.of(context).learn,
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.lime,
                icon: const Icon(Icons.games),
                label: S.of(context).game,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: S.of(context).setup,
              ),
            ],
            onTap: (option) {
              developer.log(option.toString());
              switch (option) {
                case 0:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Learning()));
                  break;
                // case 2:
                //   Navigator.of(context).pop();
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               Game(user: user)));
                //   break;
                case 2:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserSettings()));
                  break;
              }
            },
            selectedItemColor: Colors.pink));
  }
}
