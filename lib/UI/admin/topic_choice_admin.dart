import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/admin/practice_upload.dart';
import 'package:math/UI/admin/quiz_upload.dart';
import 'package:math/UI/admin/theory_upload.dart';
import '../../Model/TopicModel.dart';
import '../../generated/l10n.dart';

class TopicChoiceAdmin extends StatefulWidget {
  late SectionModel section;
  late String lang;
  late String type;

  TopicChoiceAdmin(
      {Key? key, required this.section, required this.lang, required this.type})
      : super(key: key);

  @override
  State<TopicChoiceAdmin> createState() => _TopicChoiceAdmin();
}

class _TopicChoiceAdmin extends State<TopicChoiceAdmin> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late User? user;
  late String lang;
  late String type;
  late SectionModel section;
  late List<TopicModel> topics = [
    TopicModel(id: "temo", name: "Loading...", sectionId: "temp", lang: "en_US")
  ];
  late List<String> completedTopics = [];
  bool connected = true;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    section = widget.section;
    lang = widget.lang;
    type = widget.type;
    initConnect();
    if (connected) {
      initTopicList(section);
    } else {
      topics = [];
    }
    super.initState();
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
    }, onError: (e) => print("Error fetching topics by section"));
    setState(() {});
  }

  next(TopicModel topicModel) {
    if (type == "2") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadTheory(
                    container: topicModel.id,
                  )));
    } else if (type == "3") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadPractice(
                    container: topicModel.id,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadQuiz(
                    type: type,
                    container: topicModel.id,
                  )));
    }
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(S.of(context).topicChoice),
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
                Column(children: [
                  ListTile(
                    leading: const Icon(
                      Icons.stars,
                    ),
                    title: TextButton(
                        onPressed: () {
                          if(connected) {
                            next(i);
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
                        child: Text(
                          i.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                  ),
                  const Divider(height: 0),
                ])
            ],
          ),
        ),
      ),
    );
  }
}
