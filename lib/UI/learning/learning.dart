import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Database/sqliteHandler.dart';
import 'package:math/Model/QuizModel.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz_section.dart';
import 'package:math/UI/learning/topic_choice.dart';
import 'package:math/generated/l10n.dart';
import 'package:sqflite/sqflite.dart';

import '../../Model/TopicModel.dart';
import '../settings/settings.dart';

class Learning extends StatefulWidget {
  const Learning({
    Key? key,
  }) : super(key: key);

  @override
  State<Learning> createState() => _Learning();
}

class _Learning extends State<Learning> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late User? user;
  List<QuizModel> quizList = [];
  late String level;
  late String lang;
  String userRole = "";
  SqliteHandler sql = SqliteHandler();
  bool connected = true;
  late List<TopicModel> topicList = [];
  late List<SectionModel> sectionList = [
    SectionModel(id: "temp", name: "Loading...", level: "0", lang: "en")
  ];
  late List<String> completedSections = [];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // lang = Platform.localeName;

    initConnect();
    level = "0";
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

  @override
  Future<void> didChangeDependencies() async {
    lang = Localizations.localeOf(context).languageCode.toString();

    await initConnect();
    if (connected) {
      initLevel();
      initRole();
    } else {
      try {
        level = await sql.getCurrentLevel();
        sectionList = [];
        sectionList = await sql.getSectionsByLevel(level);
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    }
    setState(() {});
    super.didChangeDependencies();
  }

  initLevel() async {
    await db.collection("UserLevel").doc(user?.uid).get().then(
        (querySnapshot) async {
      print("level completed");
      level = querySnapshot["level"];
      await db
          .collection("Section")
          .where("level", isEqualTo: level)
          .where("lang", isEqualTo: lang)
          .get()
          .then((querySnapshot) async {
        print("sections by level completed");
        sectionList = [];
        for (var docSnapshot in querySnapshot.docs) {
          sectionList.add(SectionModel(
              id: docSnapshot.id,
              name: docSnapshot.data()["name"],
              level: docSnapshot.data()["level"],
              lang: docSnapshot.data()["lang"]));
        }
        await db
            .collection("SectionQuizCompleted")
            .where("user", isEqualTo: user?.uid)
            .get()
            .then((value) async {
          for (var item in value.docs) {
            completedSections.add(item["section"]);
          }
        });
      }, onError: (e) => print("Error fetching completed quiz sections"));
    }, onError: (e) => print("Error fetching sections by level"));
    setState(() {});
  }

  Future<void> clearPractice(topic) async {
    var collection = FirebaseFirestore.instance
        .collection('Practice')
        .where("topicId", isEqualTo: topic.id);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearQuiz(topic) async {
    var collection = FirebaseFirestore.instance
        .collection('Quiz')
        .where("topicId", isEqualTo: topic.id);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearTheory(topic) async {
    var collection = FirebaseFirestore.instance
        .collection('Theory')
        .where("topicId", isEqualTo: topic.id);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearSectionQuiz(index) async {
    var collection = FirebaseFirestore.instance
        .collection('Quiz')
        .where("section", isEqualTo: index.id);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  deleteTopic(index) {
    try {
      clearPractice(index);
      clearQuiz(index);
      clearTheory(index);
      setState(() {});
      final collection = FirebaseFirestore.instance.collection('Topic');
      collection
          .doc(index.id) // <-- Doc ID to be deleted.
          .delete() // <-- Delete
          .then((_) => {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).deletedSuccessfully)))
              })
          .catchError((e) => {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).deleteFailed)))
              });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).deleteFailed)));
    }
  }

  initTopicList(SectionModel index) async {
    await db
        .collection("Topic")
        .where("section", isEqualTo: index.id)
        .where("lang", isEqualTo: lang)
        .get()
        .then((querySnapshot) async {
      print("topics by section completed");
      topicList = [];
      for (var docSnapshot in querySnapshot.docs) {
        topicList.add(TopicModel(
            id: docSnapshot.id,
            name: docSnapshot.data()["name"],
            lang: docSnapshot.data()["lang"],
            sectionId: docSnapshot.data()["section"]));
      }
    }, onError: (e) => print("Error fetching topics by section"));
    setState(() {});
  }

  initQuizzes(index) async {
    await db
        .collection("Quiz")
        .where("section", isEqualTo: index.id)
        .get()
        .then((querySnapshot) async {
      quizList = [];
      for (var docSnapshot in querySnapshot.docs) {
        quizList.add(QuizModel(
            id: docSnapshot.id,
            topicId: docSnapshot["topicId"],
            section: docSnapshot["section"],
            content: docSnapshot["content"],
            equation: docSnapshot["equation"],
            img: docSnapshot["img"],
            result: docSnapshot["result"],
            solutions: docSnapshot["solutions"]));
      }
    }, onError: (e) => print("Error fetching quizzes by section"));
    setState(() {});
  }

  deleteSection(index) async {
    await initQuizzes(index);
    await initTopicList(index);
    for (var topic in topicList) {
      await deleteTopic(topic);
    }
   await clearSectionQuiz(index);
    try {
      final collection = FirebaseFirestore.instance.collection('Section');
      collection
          .doc(index.id) // <-- Doc ID to be deleted.
          .delete() // <-- Delete
          .then((_) => {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Deleted section")))
              })
          .catchError((e) => {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).deleteFailed)))
              });
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).deleteFailed)));
    }
    sectionList.remove(index);
    setState(() {});
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
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.8),
            ),
            child: ListView(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).chooseChapter,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.withOpacity(0.7)),
                    )),
                const Divider(
                  height: 0,
                  indent: 40,
                  endIndent: 40,
                  color: Colors.teal,
                ),
                for (var i in sectionList)
                  Column(children: [
                    ListTile(
                      leading: userRole == "admin"
                          ? IconButton(
                              onPressed: () {
                                deleteSection(i);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete_forever_rounded))
                          : const Icon(Icons.star_border),
                      title: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TopicChoice(section: i)));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.1)),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.pinkAccent.withOpacity(0.3)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ))),
                          child: Text(
                            i.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizSection(
                                        section: i,
                                      )));
                        },
                        icon: Icon(Icons.question_answer_rounded,
                            color: completedSections.contains(i.id)
                                ? Colors.cyan
                                : Colors.black45),
                      ),
                    ),
                    const Divider(height: 0),
                  ])
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal.shade400,
            selectedItemColor: Colors.pink.withOpacity(0.8),
            unselectedItemColor: Colors.teal.shade900.withOpacity(0.8),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: S.of(context).learn,
              ),
              BottomNavigationBarItem(
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
            }));
  }
}

// child: ExpansionPanelList.radio(
// children: contentList.keys.map(
// (section) =>
// ExpansionPanelRadio(
// value: section.id,
// headerBuilder: (context, isExpanded) =>
// ListTile(
// title: Text(section.name),
// ),
// body:
// Container()
// )
// )).toList()
// ),
