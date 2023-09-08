import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:sqflite/sqflite.dart';

import '../../Database/sqliteHandler.dart';
import '../../Model/SectionModel.dart';
import '../../Model/TheoryModel.dart';
import '../../generated/l10n.dart';

class Theory extends StatefulWidget {
  late TopicModel topic;
  late SectionModel section;

  @override
  State<Theory> createState() => _Theory();

  Theory({Key? key, required this.topic, required this.section})
      : super(key: key);
}

class _Theory extends State<Theory> {
  late User? user;
  late TopicModel topic;
  late SectionModel section;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<TheoryModel> theoryList = [];
  bool connected = true;
  bool downloaded = false;
  late TheoryModel t;
  bool enabled = false;
  String userRole = "";
  SqliteHandler sql = SqliteHandler();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    topic = widget.topic;
    section = widget.section;
    // topic=TopicModel(id: "di5oYBaHX4PjAmIBnu4K", name: "Temp", sectionId: "temp", lang: "en_UK");
    initConnect();
    if (connected) {
      initTheoryList();
      initRole();
    } else {
      initFromDb();
    }
    isDownloaded();
    super.initState();
  }

  isDownloaded() async {
    downloaded = await sql.isTheorySaved(topic.id);
    setState(() {});
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

  initFromDb() async {
    {
      theoryList = [];
      theoryList = await sql.getTheoryModelsByTopic(topic.id);
      enabled = true;
      setState(() {});
    }
  }

  Future<void> deletePractice(theory) async {
    final collection = FirebaseFirestore.instance.collection('Theory');
    collection
        .doc(theory.id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).deletedSuccessfully)))
            })
        .catchError((e) => {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).deleteFailed)))
            });
  }

  downloadTheory() async {
    if (downloaded) {
      try {
        for (var t in theoryList) {
          await sql.deleteById(t.id, "Theory");
        }
        bool practice = await sql.arePracticesInTopic(topic.id);
        bool quiz = await sql.isQuizSaved(topic.id);
        bool theory = await sql.isTheorySaved(topic.id);
        if (!practice && !quiz && !theory) {
          await sql.deleteById(topic.id, "Topic");
          bool topics = await sql.areTopicsInSection(topic.sectionId);
          bool sectionQuiz = await sql.isSectionQuizSaved(topic.sectionId);
          if (!topics && !sectionQuiz) {
            await sql.deleteById(topic.sectionId, "Section");
          }
        }
        var temp = await sql.isTheorySaved(topic.id);
        setState(() {
          downloaded = temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    } else if (connected) {
      try {
        bool isSection = await sql.isSectionSaved(topic.sectionId);
        if (!isSection) {
          await sql.insertSection(section);
          bool isTopic = await sql.isTopicSaved(topic.id);
          if (!isTopic) {
            await sql.insertTopic(topic);
          }
        }
        for (var t in theoryList) {
          await sql.insertTheoryModel(t);
        }
        var temp = await sql.isTheorySaved(topic.id);
        setState(() {
          downloaded = temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    }
  }

  initTheoryList() async {
    await db
        .collection("Theory")
        .where("topicId", isEqualTo: topic.id)
        .get()
        .then((querySnapshot) {
      print("theory by topic completed");
      theoryList = [];
      for (var docSnapshot in querySnapshot.docs) {
        print(docSnapshot.data());
        theoryList.add(TheoryModel(
            id: docSnapshot.id,
            img: docSnapshot.data()["img"],
            topicId: docSnapshot.data()["topicId"]));
        print(theoryList.length);
        enabled = true;
      }
    }, onError: (e) => print("Error fetching theory by topic"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
        appBar: AppBar(
          title: Text(topic.name),
        ),
        body: theoryList.isNotEmpty
            ? PageView(
                controller: controller,
                children: <Widget>[
                  for (var i = 0; i < theoryList.length; i++)
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (theoryList[i].img != "None")
                          CachedNetworkImage(
                            imageUrl: theoryList[i].img,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                          ),
                        if (userRole == "admin")
                          FloatingActionButton.extended(
                            heroTag: "btn2",
                            onPressed: () {
                              deletePractice(theoryList[i]);
                              i += 1;
                              setState(() {});
                            },
                            label: Text(S.of(context).delete),
                            backgroundColor: Colors.pink,
                            icon: const Icon(Icons.delete_forever_rounded),
                          ),
                      ],
                    )
                        //Image.network(i.img),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          if (enabled) {
                            downloadTheory();
                            setState(() {});
                          }
                        },
                        label: downloaded == true
                            ? Text(S.of(context).downloaded)
                            : Text(S.of(context).download),
                        backgroundColor:
                            downloaded == true ? Colors.pink : Colors.teal,
                        icon: const Icon(Icons.download_rounded),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(S.of(context).noTheorySubmittedForThisTopic),
                  )
                ],
              ));
  }
}
