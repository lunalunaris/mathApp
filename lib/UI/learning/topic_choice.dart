import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Database/sqliteHandler.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/game/scene.dart';
import 'package:math/UI/learning/topic.dart';

import '../../Model/TopicModel.dart';
import '../../generated/l10n.dart';
import '../settings/settings.dart';
import 'learning.dart';

class TopicChoice extends StatefulWidget {
  late SectionModel section;

  TopicChoice({Key? key, required this.section}) : super(key: key);

  @override
  State<TopicChoice> createState() => _TopicChoice();
}

class _TopicChoice extends State<TopicChoice> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late User? user;
  late SectionModel section;
  late String lang;
  bool connected = true;
  late List<TopicModel> topics = [
    TopicModel(id: "temo", name: "Loading...", sectionId: "temp", lang: "en_US")
  ];
  late List<String> completedTopics = [];
  String userRole = "";

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    section = widget.section;
    // lang = Platform.localeName;
    // initTopicList(section);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    lang = Localizations.localeOf(context).languageCode.toString();
    initConnect();
    if (connected) {
      initTopicList(section);
      initRole();
    } else {
      initFromDb();
    }
    setState(() {});
    super.didChangeDependencies();
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  initFromDb() async {
    topics = [];
    SqliteHandler sql = SqliteHandler();
    topics = await sql.getTopicsBySection(section.id);
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

  deleteTopic(index) {
    try {
      clearPractice(index);
      clearQuiz(index);
      clearTheory(index);
      topics.remove(index);
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

  initTopicList(SectionModel section) async {
    await db
        .collection("Topic")
        .where("section", isEqualTo: section.id)
        .where("lang", isEqualTo: lang)
        .get()
        .then((querySnapshot) async {
      print("topics by section completed");
      topics = [];
      for (var docSnapshot in querySnapshot.docs) {
        topics.add(TopicModel(
            id: docSnapshot.id,
            name: docSnapshot.data()["name"],
            lang: docSnapshot.data()["lang"],
            sectionId: docSnapshot.data()["section"]));
      }
      await db
          .collection("TopicQuizCompleted")
          .where("user", isEqualTo: user?.uid)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          completedTopics.add(item["topic"]);
        }
      });
    }, onError: (e) => print("Error fetching topics by section"));
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
              child: ListView(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).chooseTopic,
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
                for (var i in topics)
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.stars,
                            color: completedTopics.contains(i.id)
                                ? Colors.cyan
                                : Colors.black45),
                        title: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Topic(
                                            topic: i,
                                            section: section,
                                          )));
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
                            child: Text(
                              i.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            )),
                        trailing: userRole == "admin"
                            ? IconButton(
                                onPressed: () {
                                  deleteTopic(i);
                                },
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  size: 30,
                                ))
                            : Text(""),
                      ),
                    ],
                  ),
                const Divider(height: 0),
              ])),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal.shade400,
            selectedItemColor: Colors.pink.withOpacity(0.8),
            currentIndex: 0,
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
              switch (option) {
                case 0:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Learning()));
                  break;
                case 1:
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Scene()));
                  break;

                case 1:
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
