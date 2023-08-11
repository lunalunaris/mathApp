import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Database/FireStoreHandler.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/admin/topic_choice_admin.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/UI/learning/quiz_section.dart';
import 'package:math/UI/learning/topic_choice.dart';
import 'dart:developer' as developer;
import '../settings/settings.dart';

class SectionChoice extends StatefulWidget {
  late String? level;
  late String lang;
  late String type;
   SectionChoice({
    Key? key, required this.level, required this.lang, required this.type
  }) : super(key: key,);

  @override
  State<SectionChoice> createState() => _SectionChoice();
}

class _SectionChoice extends State<SectionChoice> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late User? user;
  bool flag=true;
  late String? level;
  late String lang;
  late String type;
  late SectionModel section;
  late FirestoreHandler fs = FirestoreHandler();
  TextEditingController controller = TextEditingController();
  late List<SectionModel> sections = [
    SectionModel(id: "temo", name: "Loading...", level: "0", lang: "en_US")
  ];
  late List<String> completedSections=[];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    lang = widget.lang;
    level = widget.level;
    type = widget.type;
    initLevel();
    super.initState();
  }
  Future<void> addTopic() async {
    db.collection("Topic").add({"lang": lang,"name": controller.text, "section": section.id});
  }

  submitToDB(){
    addTopic();
    //popup
    setState(() {flag=false;});
  }

  initLevel() async {
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
          }, onError: (e) => print("Error fetching sections by level"));
    setState(() {});
  }

  next(){
    if(type=="topic"){
        flag=false;
        setState(() {
        });
    }
    else if(type=="section quiz"){
      //navigate to final view - pass type, section and lang
    }
    else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TopicChoiceAdmin(section: section, lang: lang, type: type,)
          )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Section Choice"),
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
            child: flag? buildListView(context):buildTopicInput(context),
          ),
        ),

    );
  }
  buildTopicInput(BuildContext context){

    return Column(
      children: [
        const Text(
          "Submit name for your topic",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            )),
        ElevatedButton(onPressed: (){
          submitToDB();
        }, child: const Text("Submit"))
      ],
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
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
                          section=i;
                          setState(() {
                          });
                            next();
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
                  ),
                  const Divider(height: 0),
                ])
            ],
          );
  }
}
