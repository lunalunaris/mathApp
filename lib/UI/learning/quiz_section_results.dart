import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/UI/learning/quiz_section.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';




class QuizSectionResults extends StatefulWidget {
  late SectionModel section;
  late double percent;

  @override
  State<QuizSectionResults> createState() => _QuizSectionResults();

  QuizSectionResults({Key? key, required this.section, required this.percent})
      : super(key: key);
}

class _QuizSectionResults extends State<QuizSectionResults> {
  late SectionModel section;
  late double percent;
  late User? user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String stringPercent = " ";

  @override
  void initState() {
    section = widget.section;
    percent = widget.percent;
    user = FirebaseAuth.instance.currentUser;
    completedSections(section.id);
    super.initState();
  }

  Future<void> completedSections(String sectionId) async {
    db
        .collection("SectionQuizCompleted")
        .add({"user": user!.uid, "section": sectionId});
  }

  @override
  Widget build(BuildContext context) {
    stringPercent = "${percent.toString()}" + "%";
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Quiz"),
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
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: percent / 100,
                        center: Text(
                          stringPercent,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.indigo.shade100,
                        // progressColor: Colors.pink,
                        linearGradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.pink],
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: const Text("Questions correct")),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizSection(
                                        section: section,
                                      )));
                            },
                            child: const Text("Try again?"))),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Quit")))
                  ],
                ))));
  }
}
