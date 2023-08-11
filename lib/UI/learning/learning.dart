import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Database/FireStoreHandler.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/UI/learning/quiz_section.dart';
import 'package:math/UI/learning/topic_choice.dart';
import 'dart:developer' as developer;
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

  late String level;
  late String lang;
  late FirestoreHandler fs = FirestoreHandler();
  late List<SectionModel> sections = [
    SectionModel(id: "temo", name: "Loading...", level: "0", lang: "en_US")
  ];
  late List<String> completedSections=[];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    lang = Platform.localeName;
    level = "0";
    initLevel();
    super.initState();
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
        sections = [];
        for (var docSnapshot in querySnapshot.docs) {
          sections.add(SectionModel(
              id: docSnapshot.id,
              name: docSnapshot.data()["name"],
              level: docSnapshot.data()["level"],
              lang: docSnapshot.data()["lang"]));
        }
        await db.collection("SectionQuizCompleted").where("user", isEqualTo: user?.uid).get().then((value) async{
          for(var item in value.docs){
            completedSections.add(item["section"]);
          }
        });
      }, onError: (e) => print("Error fetching sections by level"));
    }, onError: (e) => print("Error fetching sections by level"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Learning"),
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
                      "Choose chapter",
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
                for (var i in sections)
                  Column(children: [
                    ListTile(
                      leading: const Icon(Icons.star_border),
                      title: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TopicChoice(section: i)
                                )
                            );
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => QuizSection(section: i,)));
                          },
                          icon:  Icon(Icons.question_answer_rounded, color: completedSections.contains(i.id)?Colors.cyan:Colors.black45),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserSettings()));
                  break;
              }
            })
    );
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
