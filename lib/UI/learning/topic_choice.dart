import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Database/FireStoreHandler.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/topic.dart';
import 'dart:developer' as developer;
import '../../Model/TopicModel.dart';
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
  late FirestoreHandler fs = FirestoreHandler();

  late List<TopicModel> topics = [
    TopicModel(id: "temo", name: "Loading...", sectionId: "temp", lang: "en_US")
  ];
  late List<String> completedTopics=[];
  @override
  void initState() {
    user =FirebaseAuth.instance.currentUser;
    section = widget.section;
    initTopicList(section);
    super.initState();
  }


  initTopicList(SectionModel section) async {
    await db
        .collection("Topic")
        .where("section", isEqualTo: section.id)
        .where("lang", isEqualTo: "en_US")
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
      await db.collection("TopicQuizCompleted").where("user", isEqualTo: user?.uid).get().then((value) async{
        for(var item in value.docs){
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
                Container(padding: EdgeInsets.all(10),alignment: Alignment.center,
                    child: Text("Choose topic", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.teal.withOpacity(0.7)),)),
                const Divider(height: 0,indent: 40, endIndent: 40,color: Colors.teal,),
                for (var i in topics)
                  Column(children: [
                    ListTile(
                      leading:  Icon(Icons.stars,color: completedTopics.contains(i.id)?Colors.cyan:Colors.black45),
                      title: TextButton(
                          onPressed: () {Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                   Topic(topic: i)));},
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
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal.shade400,
            selectedItemColor: Colors.pink.withOpacity(0.8),
            currentIndex: 0,
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
              switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Learning()));
                break;
                case 2:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSettings()));
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
